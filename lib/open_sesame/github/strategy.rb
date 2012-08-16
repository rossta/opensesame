# encoding: utf-8
require 'warden'

module OpenSesame
  module Github
    class Strategy < ::Warden::Strategies::Base
      attr_writer :organization

      def valid?
        auth_hash && auth_hash["provider"] == "github"
      end

      def authenticate!
        if team_member = organization.find_team_member(auth_hash["uid"])
          success! team_member
        else
          fail 'Sorry, you do not have access'
        end
      end

      def auth_hash
        request.env['opensesame.auth']
      end

      def organization
        @organization ||= OpenSesame::Github.organization
      end
    end

  end
end

Warden::Strategies.add(:opensesame_github, OpenSesame::Github::Strategy)