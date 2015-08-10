# encoding: utf-8
module OpenSesame
  class ConfigurationError < RuntimeError; end

  class Configuration
    CONFIGURABLE_ATTRIBUTES = [
      :organization_name,
      :mount_prefix,
      :github_application,
      :enabled,
      :debug,
      :full_host,
      :auto_access_provider,
      :after_login_path,
      :after_logout_path
    ]
    attr_accessor *CONFIGURABLE_ATTRIBUTES

    def mounted_at(mount_prefix)
      self.mount_prefix = mount_prefix
    end

    def host(full_host)
      self.full_host = full_host
    end

    def github(client_id, client_secret)
      self.github_application = { :client_id => client_id, :client_secret => client_secret }
    end

    def github_access_token(access_token)
      self.github_application = { :access_token => access_token }
    end

    def organization(organization_name)
      self.organization_name = organization_name
    end

    def auto_login(provider)
      self.auto_access_provider = provider
    end

    def enable!
      self.enabled = true
    end

    def disable!
      self.enabled = false
    end

    def enable(enabled)
      self.enabled = !!enabled
    end

    def redirect_to(to)
      self.after_login_path = to
      self.after_logout_path = to
    end

    def redirect_after_login(to)
      self.after_login_path = to
    end

    def redirect_after_logout(to)
      self.after_logout_path = to
    end

    def enabled?
      !!self.enabled
    end

    def debug?
      !!self.debug
    end

    def configure
      yield self
      validate!
      self
    end

    def valid?
      self.organization_name && self.organization_name.is_a?(String) &&
      self.mount_prefix && self.mount_prefix.is_a?(String) &&
      self.github_application.is_a?(Hash) &&
      [:client_id, :client_secret].all? { |key| self.github_application.keys.include?(key) }
    end

    def configured?
      [:organization_name, :mount_prefix, :github_application].any? { |required| send(required).present? }
    end

    def validate!
      return true if valid?
      message = <<-MESSAGE

      Update your OpenSesame configuration. Example:

      # config/initializers/open_sesame.rb
      OpenSesame.configure do |config|
        config.organization 'challengepost'
        config.mounted_at   '/opensesame'
        config.github       ENV['GITHUB_APP_ID'], ENV['GITHUB_SECRET']
      end

      When you register the app, make sure to point the callback url to
      the engine mountpoint + /auth/github/callback. For example, if your
      development app is on http://localhost:3000 and you're mounting
      the OpenSesame::Engine at '/opensesame', your github
      callback url should be:

      http://localhost:3000/auth/github/callback

      MESSAGE

      raise ConfigurationError.new(message)
    end

  end
end
