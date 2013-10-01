# encoding: utf-8
require 'warden'

module OpenSesame
  class GithubWarden < ::Warden::Strategies::Base

    def valid?
      auth_hash && auth_hash["provider"] == "github"
    end

    def authenticate!
      if member = OpenSesame::Member.find(github_login)
        success! member
      else
        fail 'Sorry, you do not have access'
      end
    end

    def github_login
      auth_hash['info']['nickname']
    end

    def auth_hash
      request.env['omniauth.auth']
    end

  end
end

::Warden::Strategies.add(:opensesame_github, OpenSesame::GithubWarden)
