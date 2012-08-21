# encoding: utf-8
module OpenSesame
  class ConfigurationError < RuntimeError; end

  class Configuration
    CONFIGURABLE_ATTRIBUTES = [
      :organization_name,
      :mount_prefix,
      :client_id,
      :client_secret,
      :enabled, :enable_clause,
      :full_host,
      :auto_access,
      :provider_name,
      :test_mode,
      :mock_auth
    ]
    attr_accessor *CONFIGURABLE_ATTRIBUTES

    def clear_configuration!
      CONFIGURABLE_ATTRIBUTES.each { |attribute| send("#{attribute}=", nil) }
    end

    def mounted_at(mount_prefix)
      self.mount_prefix = mount_prefix
    end

    def host(full_host)
      self.full_host = full_host
    end

    def client(client_id, client_secret)
      self.client_id = client_id
      self.client_secret = client_secret
    end

    def organization(organization_name)
      self.organization_name = organization_name
    end

    def provider(provider_name)
      self.provider_name = provider_name
    end

    def client_options
      strategy.client_options
    end

    def strategy
      @strategy ||= "OpenSesame::AuthStrategies::#{self.provider_name.titleize}".constantize.new
    end

    def enable_auto_access(enabled)
      self.auto_access = !!enabled
    end

    def enable_if(conditional)
      self.enabled = nil
      self.enable_clause = lambda { conditional }
    end

    def enable!
      self.enable_clause = nil
      self.enabled = true
    end

    def disable!
      self.enable_clause = nil
      self.enabled = false
    end

    def enabled?
      (!self.enabled.nil? && self.enabled) ||
      (!self.enable_clause.nil? && self.enable_clause.call)
    end

    def configure
      yield self
    end

    def valid?
      self.organization_name && self.organization_name.is_a?(String) &&
      self.provider_name && self.provider_name.is_a?(String) &&
      self.mount_prefix && self.mount_prefix.is_a?(String) &&
      self.client_id && self.client_secret
    end

    def configured?
      [:organization_name, :mount_prefix, :client_id, :client_secret].any? { |required| send(required).present? }
    end

    def validate!
      return true if valid?
      message = <<-MESSAGE

      Update your OpenSesame configuration. Example:

      # config/initializers/open_sesame.rb
      OpenSesame.configure do |config|
        config.organization 'challengepost'
        config.mounted_at   '/opensesame'
        config.client       ENV['SESAMESTREET_APP_ID'], ENV['SESAMESTREET_SECRET']
      end

      When you register the app, make sure to point the callback url to
      the engine mountpoint + /auth/github/callback. For example, if your
      development app is on http://localhost:3000 and you're mounting
      the OpenSesame::Engine at '/opensesame', your github
      callback url should be:

      http://localhost:3000/opensesame/auth/callback

      MESSAGE

      raise ConfigurationError.new(message)
    end

    def mock_with(options = {})
      @mock_auth = AuthHash.new(options)
    end

    def mock_auth(options = {})
      @mock_auth ||= mock_with(options)
    end

  end
end