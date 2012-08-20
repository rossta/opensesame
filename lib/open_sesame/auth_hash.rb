module OpenSesame
  class AuthHash

    attr_accessor :access_token, :options

    def initialize(options = {})
      @access_token = options.delete(:access_token)
      @options = HashWithIndifferentAccess.new(options)
    end

    def [](key)
      auth_hash[key]
    end

    def []=(key, value)
      auth_hash[key] = value
    end

    def valid?
      auth_hash['uid'].present? &&
      auth_hash['provider'].present? &&
      auth_hash['info'] && auth_hash['info']['name'].present?
    end

    def auth_hash
      @auth_hash ||= to_hash
    end

    def to_hash
      {}.tap do |hash|
        hash['uid'] = uid
        hash['provider'] = provider
        hash['info'] = info
        hash['credentials'] = credentials
        hash['extra'] = extra
      end
    end

    def uid
      options['uid'] || raw_info['id']
    end

    def info
      {
        'nickname' => raw_info['nickname'],
        'email' => raw_info['email'],
        'name' => raw_info['name']
      }
    end

    def credentials
      # access token request to /me
      {}.tap do |hash|
        if access_token
          hash['token'] = access_token.token
          hash['refresh_token'] = access_token.refresh_token if access_token.expires? && access_token.refresh_token
          hash['expires_at'] = access_token.expires_at if access_token.expires?
          hash['expires'] = access_token.expires?
        end
      end
    end

    def extra
      { 'raw_info' => raw_info }
    end

    def raw_info
      return options['raw_info'] if options['raw_info'] && options['raw_info'].is_a?(Hash)
      return {} unless access_token
      access_token.options[:mode] = :query
      @raw_info ||= access_token.get('/api/me').parsed
    end

    def provider
      options['provider']
    end

  end
end