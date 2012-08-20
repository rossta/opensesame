module OpenSesame
  class AuthHash

    attr_accessor :access_token, :options

    def initialize(access_token, options = {})
      @access_token, @options = access_token, options
    end

    def to_hash
      {'uid' => uid, 'provider' => provider }.tap do |hash|
        hash['info'] = info
        hash['credentials'] = credentials
        hash['extra'] = extra
      end
    end

    def uid
      raw_info['id']
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
        hash['token'] = access_token.token
        hash['refresh_token'] = access_token.refresh_token if access_token.expires? && access_token.refresh_token
        hash['expires_at'] = access_token.expires_at if access_token.expires?
        hash['expires'] = access_token.expires?
      end
    end

    def extra
      { 'raw_info' => raw_info }
    end

    def raw_info
      access_token.options[:mode] = :query
      @raw_info ||= access_token.get('/api/me').parsed
    end

    def provider
      options[:provider]
    end

  end
end