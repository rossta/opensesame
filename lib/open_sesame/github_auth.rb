# encoding: utf-8
require 'omniauth-github'

module OpenSesame
  class GithubAuth < ::OmniAuth::Strategies::GitHub
    option :name, 'github'
    option :path_prefix, OpenSesame.mount_prefix
    option :on_failure, OpenSesame::Failure::App.new

    # overrides OmniAuth::Strategy#fail!
    def fail!(message_key, exception = nil)
      self.env['omniauth.error'] = exception
      self.env['omniauth.error.type'] = message_key.to_sym
      self.env['omniauth.error.strategy'] = self

      if exception
        log :error, "Authentication failure! #{message_key}: #{exception.class.to_s}, #{exception.message}"
      else
        log :error, "Authentication failure! #{message_key} encountered."
      end

      options.on_failure.call(self.env)
    end
  end
end
