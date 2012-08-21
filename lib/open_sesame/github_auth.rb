require 'omniauth-github'

module OpenSesame
  class GithubAuth < ::OmniAuth::Strategies::GitHub
    option :name, 'github'
    option :path_prefix, OpenSesame.mount_prefix
  end
end