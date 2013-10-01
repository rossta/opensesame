# encoding: utf-8
require "octokit"

module OpenSesame
  class Member

    def self.organization_name
      OpenSesame.organization_name
    end

    def self.find(member_id)
      return nil unless member_id.present?
      attributes = organization_members.detect { |member| member.id.to_s == member_id.to_s }
      return nil unless attributes.present?
      new(attributes)
    end

    # memoize members so we don't make repeated API requests
    def self.organization_members
      @organization_members ||= github_api.organization_members(organization_name)
    end

    # necessary to update when changes made to the GH organization
    def self.reset_organization_members
      @organization_members = nil
    end

    def self.github_api
      @github_api ||= begin
        if OpenSesame.github_account
          Octokit::Client.new(
            :login => OpenSesame.github_account[:login],
            :oauth_token => OpenSesame.github_account[:oauth_token])
        else
          Octokit.new
        end
      end
    end

    def self.lazy_attr_reader(*attrs)
      attrs.each do |attribute|
        class_eval do
          define_method(attribute) do
            @attributes[attribute.to_s] || @attributes[attribute] # allow string or symbol access
          end
        end
      end
    end

    def self.serialize_into_session(member)
      [member.id]
    end

    def self.serialize_from_session(*args)
      id = args.shift
      find(id)
    end

    attr_accessor :attributes
    lazy_attr_reader :id, :login, :avatar_url, :gravatar_id, :url

    def initialize(attributes = {})
      @attributes = attributes
    end

    def id
      @attributes["id"]
    end

    def organization_name
      self.class.organization_name
    end

    def ==(other)
      super || (other.class == self.class && other.id == self.id)
    end

  end
end
