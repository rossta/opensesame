# encoding: utf-8
require "octokit"

module OpenSesame
  class Member

    def self.organization_name
      OpenSesame.organization_name
    end

    def self.find(member_id)
      attributes = organization_members.detect { |member| member.id.to_s == member_id.to_s }
      new(attributes)
    end

    def self.organization_members
      Octokit.new.organization_members(organization_name)
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