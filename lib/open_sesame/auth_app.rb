# encoding: utf-8
require 'oauth2'

module OpenSesame
  class AuthApp
    class_attribute :site, :provider

    attr_accessor :options, :access_token, :env

    # @options = {
    #   'client_id' => 'client_id',
    #   'client_secret' => 'client_secret'
    # }
    def initialize(app, options = {}, &block)
      @app = app
      @options = default_options.merge(options)
    end

    def call(env)
      # raise OmniAuth::NoSessionError.new("You must provide a session to use OmniAuth.") unless env['rack.session']
      @env = env
      @request = Rack::Request.new(@env)
      @env['opensesame.strategy'] = self if on_path?(request_path) || on_path?(callback_path)
      return mock_call if OpenSesame.configuration.test_mode
      return request_call if on_path?(request_path)
      return callback_call if on_path?(callback_path)
      call_app(env)
    end

    def call_app(env = @env)
      @app.call(env)
    end

    def default_options
      {
        :client_options => OpenSesame.strategy.client_options
      }
    end

    def log(level, message)
      Rails.logger.send(level, "[OpenSesame] #{message}")
    end

    def client
      ::OAuth2::Client.new(options[:client_id], options[:client_secret], options[:client_options])
    end

    def provider
      OpenSesame.strategy.name
    end

    # PHASES #

    # Performs the steps necessary to run the request phase of a strategy.
    def request_call
      log :info, "Request phase initiated."
      #store query params from the request url, extracted in the callback_phase
      session['opensesame.params'] = request.params

      if request.params['origin']
        session['opensesame.origin'] = request.params['origin']
      elsif env['HTTP_REFERER'] && !env['HTTP_REFERER'].match(/#{request_path}$/)
        session['opensesame.origin'] = @env['HTTP_REFERER']
      end
      request_phase
    end

    def request_phase
      redirect client.auth_code.authorize_url(:redirect_uri => callback_url)
    end

    def callback_call
      log :info, "Callback phase initiated."
      @env['opensesame.origin'] = session.delete('opensesame.origin')
      @env['opensesame.origin'] = nil if env['opensesame.origin'] == ''
      @env['opensesame.params'] = session.delete('opensesame.params') || {}
      callback_phase
    end

    def callback_phase
      if request.params['error'] || request.params['error_reason']
        raise CallbackError.new(request.params['error'], request.params['error_description'] || request.params['error_reason'], request.params['error_uri'])
      end
      self.access_token = build_access_token
      self.access_token = access_token.refresh! if access_token.expired?

      self.env['opensesame.auth'] = auth_hash
      call_app
    rescue ::OAuth2::Error, CallbackError => e
      fail!(:invalid_credentials, e)
    rescue ::MultiJson::DecodeError => e
      fail!(:invalid_response, e)
    rescue ::Timeout::Error, ::Errno::ETIMEDOUT => e
      fail!(:timeout, e)
    rescue ::SocketError => e
      fail!(:failed_to_connect, e)
    end

    # This is called in lieu of the normal request process
    # in the event that OmniAuth has been configured to be
    # in test mode.
    def mock_call
      return mock_request_call if on_path?(request_path)
      return mock_callback_call if on_path?(callback_path)
      call_app
    end

    def mock_request_call
      if request.params['origin']
        session['opensesame.origin'] = request.params['origin']
      elsif env['HTTP_REFERER'] && !env['HTTP_REFERER'].match(/#{request_path}$/)
        session['opensesame.origin'] = env['HTTP_REFERER']
      end
      redirect(script_name + callback_path + query_string)
    end

    def mock_callback_call
      mocked_auth = OpenSesame.mock_auth
      @env['opensesame.auth'] = mocked_auth
      @env['opensesame.params'] = session.delete('query_params') || {}
      @env['opensesame.origin'] = session.delete('opensesame.origin')
      @env['opensesame.origin'] = nil if env['opensesame.origin'] == ''
      call_app
    end

    # PATHS #

    def on_path?(path)
      current_path.casecmp(path) == 0
    end

    def request_path
      options[:request_path] || "#{mount_prefix}/auth/#{provider}/request"
    end

    def callback_path
      options[:callback_path] || "#{mount_prefix}/auth/#{provider}/callback"
    end

    def current_path
      request.path_info.downcase.sub(/\/$/,'')
    end

    def mount_prefix
      options[:mount_prefix] || OpenSesame.configuration.mount_prefix
    end

    def callback_url
      full_host + script_name + callback_path
    end

    def full_host
      uri = URI.parse(request.url.gsub(/\?.*$/,''))
      uri.path = ''
      uri.query = nil
      #sometimes the url is actually showing http inside rails because the other layers (like nginx) have handled the ssl termination.
      uri.scheme = 'https' if(request.env['HTTP_X_FORWARDED_PROTO'] == 'https')
      uri.to_s
    end

    # Rack #

    def request
      @request ||= Rack::Request.new(@env)
    end

    def script_name
      @env['SCRIPT_NAME'] || ''
    end

    def session
      @env['rack.session']
    end

    def query_string
      request.query_string.empty? ? "" : "?#{request.query_string}"
    end

    def redirect(uri)
      Rack::Response.new.tap do |r|
        if options[:iframe]
          r.write("<script type='text/javascript' charset='utf-8'>top.location.href = '#{uri}';</script>")
        else
          r.write("Redirecting to #{uri}...")
          r.redirect(uri)
        end
      end.finish
    end

    def auth_hash
      AuthHash.new(access_token: access_token, provider: provider)
    end

    def fail!(message_key, exception = nil)
      @env['opensesame.error'] = exception
      @env['opensesame.error.type'] = message_key.to_sym
      @env['opensesame.error.strategy'] = self

      if exception
        log :error, "Authentication failure! #{message_key}: #{exception.class.to_s}, #{exception.message}"
      else
        log :error, "Authentication failure! #{message_key} encountered."
      end

      raise @env['opensesame'].inspect
      OpenSesame.configuration.on_failure.call(self.env)
    end

    def build_access_token
      verifier = request.params['code']
      client.auth_code.get_token(verifier, :redirect_uri => callback_url)
    end

   # An error that is indicated in the OAuth 2.0 callback.
    # This could be a `redirect_uri_mismatch` or other
    class CallbackError < StandardError
      attr_accessor :error, :error_reason, :error_uri

      def initialize(error, error_reason=nil, error_uri=nil)
        self.error = error
        self.error_reason = error_reason
        self.error_uri = error_uri
      end
    end

  end
end