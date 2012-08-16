# encoding: utf-8
module OpenSesame::Github
  class Organization < Base
    lazy_attr_reader :name

    attr_writer :team_members

    def team_members
      @team_members ||= begin
        Collection.new do |collection|
          collection.member_class = TeamMember
          collection.url          = "/orgs/#{name}/members"
          collection.fetch
        end
      end
    end

    def team_member_ids
      team_members.map(&:id)
    end

    def team_member_attributes
      team_members.map(&:attributes)
    end

    def team_member?(team_member_id)
      team_member_ids.include?(team_member_id)
    end

    def fetch_team_members
      team_members.fetch
    end

    def find_team_member(team_member_id)
      team_members.find(team_member_id)
    end

    def ==(other)
      (other.class == self.class && other.name == self.name)
    end
  end
end