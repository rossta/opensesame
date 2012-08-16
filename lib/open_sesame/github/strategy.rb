# encoding: utf-8
require 'warden'

module OpenSesame
  module Github
    class Strategy < ::Warden::Strategies::Base
      attr_writer :organization

      def valid?
        omniauth && omniauth["provider"] == "github"
      end

      def authenticate!
        if team_member = organization.find_team_member(omniauth["uid"])
          success! team_member
        else
          fail 'Sorry, you do not have access'
        end
      end

      def omniauth
        request.env['omniauth.auth']
      end

      def organization
        @organization ||= OpenSesame::Github.organization
      end
    end

  end
end

Warden::Strategies.add(:opensesame_github, OpenSesame::Github::Strategy)