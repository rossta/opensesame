module OpenSesame
  module Github
    extend self

    autoload :API, 'open_sesame/github/api'
    autoload :Base, 'open_sesame/github/base'
    autoload :Collection, 'open_sesame/github/collection'
    autoload :Organization, 'open_sesame/github/organization'
    autoload :TeamMember, 'open_sesame/github/team_member'
    autoload :Strategy, 'open_sesame/github/strategy'

    def organization_name
      @@organization_name
    end

    def organization_name=(organization_name)
      @@organization_name = organization_name
    end

    def organization
      @@organization ||= Organization.new(:name => organization_name)
    end

    def api
      @@api ||= API.new
    end

    def reset!
      @@organization_name = nil
      @@organization = nil
      @@api = nil
    end

  end
end