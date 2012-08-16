# encoding: utf-8
module OpenSesame::Github
  class TeamMember < Base
    lazy_attr_reader :id, :login, :url, :avatar_url, :gravatar_id

    class << self

      def organization
        OpenSesame::Github.organization
      end

      def serialize_into_session(record)
        [record.id]
      end

      def serialize_from_session(*args)
        id = args.shift
        organization.find_team_member(id)
      end
    end

  end
end