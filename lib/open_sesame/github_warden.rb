# encoding: utf-8
require 'warden'
require "octokit"

module OpenSesame
  class GithubWarden < ::Warden::Strategies::Base
    attr_writer :organization

    def valid?
      auth_hash && auth_hash["provider"] == "github"
    end

    def authenticate!
      if org_member = organization_member(auth_hash["uid"])
        success! org_member
      else
        fail 'Sorry, you do not have access'
      end
    end

    def organization_member(user_id)
      organization_members.detect { |member| member['id'].to_s == user_id.to_s }
    end

    def organization_members
      Octokit.new.organization_members(OpenSesame.organization_name)
    end

    def auth_hash
      request.env['omniauth.auth']
    end

  end
end

::Warden::Strategies.add(:opensesame_github, OpenSesame::GithubWarden)