# encoding: utf-8
require "octokit"

module OpenSesame
  class Member

    def self.organization_name
      OpenSesame.organization_name
    end

    def self.find(member_id)
      return nil unless member_id.present?
      return unless member?(member_id)
      new(login: member_id)
    end

    def self.member?(member_id)
      members.include?(member_id) || begin
        client.organization_member?(organization_name, member_id)
      rescue Octokit::ServerError => e
        OpenSesame.logger.info e
      end
    end

    def self.members
      @members ||= []
    end

    def self.client
      @client ||= begin
        Octokit::Client.new(OpenSesame.github_application)
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
    lazy_attr_reader :login

    def initialize(attributes = {})
      @attributes = attributes
    end

    def id; login; end

    def organization_name
      self.class.organization_name
    end

    def ==(other)
      super || (other.class == self.class && other.id == self.id)
    end

  end
end
