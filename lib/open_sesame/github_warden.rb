# encoding: utf-8
require 'warden'

module OpenSesame
  class GithubWarden < ::Warden::Strategies::Base

    def valid?
      auth_hash && auth_hash["provider"] == "github"
    end

    def authenticate!
      if member = OpenSesame::Member.find(auth_hash["nickname"])
        success! member
      else
        fail 'Sorry, you do not have access'
      end
    end

    def auth_hash
      Rails.logger.info "Github auth_hash: #{request.env['omniauth.auth']}"
      request.env['omniauth.auth']
    end

  end
end

::Warden::Strategies.add(:opensesame_github, OpenSesame::GithubWarden)
