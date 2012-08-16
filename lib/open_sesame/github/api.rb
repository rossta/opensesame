# encoding: utf-8
require 'faraday'
require 'faraday_middleware'

module OpenSesame
  module Github
    GITHUB_API_HOST = 'https://api.github.com'

    class API

      def get(path = nil)
        response = connection.get(path)
        if response.success?
          response.body
        else
          nil
        end
      end

      protected

      def connection
        @connection ||= Faraday.new(url: GITHUB_API_HOST) do |conn|
          conn.request :json

          conn.response :json, :content_type => /\bjson|javascript$/
          conn.response :logger if defined?(Rails) && !Rails.env.test?

          conn.use :instrumentation if defined?(ActiveSupport) && defined?(ActiveSupport::Notifications)
          conn.adapter Faraday.default_adapter
        end
      end
    end
  end

  # organization = Github::Organization.new('challengepost')
  # organization.team_members
  # organization.team_member?(id)
  # Github::Organization.new('challengepost').team_members.find(id)
  # organization.team_members.find(id)
end
