# encoding: utf-8
require "octokit"

module OpenSesame
  class Member

    def self.organization_name
      OpenSesame.organization_name
    end

    def self.find(member_login)
      return nil unless member_login.present?
      return unless member?(member_login)
      member = find_member(member_login) # Sawyer::Resource
      return unless member # may have been an API error
      members << member
      new(member.attrs)
    end

    def self.find_member(member_login)
      members.detect { |m| m.login == member_login } || begin
        client.user(member_login)
      rescue Octokit::Error => ek
        OpenSesame.logger.info e
      end
    end

    def self.member?(member_login)
      member_logins.include?(member_login) || begin
        client.organization_member?(organization_name, member_login)
      rescue Octokit::ServerError => e
        OpenSesame.logger.info e
      end
    end

    # memoized list of accepted member
    def self.members
      @members ||= []
    end

    def self.member_logins
      members.map(&:login)
    end

    def self.client
      @client ||= begin
        require "faraday-http-cache"
        stack = Faraday::Builder.new do |builder|
          builder.response :logger, OpenSesame.logger
          builder.use Faraday::HttpCache unless OpenSesame.debug?
          builder.use Octokit::Response::RaiseError
          builder.adapter Faraday.default_adapter
        end
        Octokit.middleware = stack
        Octokit::Client.new(OpenSesame.github_application)
      end
    end

    def self.reset
      @members = nil
    end

    def self.lazy_attr_reader(*attrs)
      attrs.each do |attribute|
        class_eval do
          define_method(attribute) do
            @attributes[attribute] || @attributes[attribute] # allow string or symbol access
          end
        end
      end
    end

    def self.serialize_into_session(member)
      [member.login]
    end

    def self.serialize_from_session(*args)
      login = args.shift
      find(login)
    end

    attr_accessor :attributes
    lazy_attr_reader :id, :login, :email

    def initialize(attributes = {})
      @attributes = attributes
    end

    def organization_name
      self.class.organization_name
    end

    def ==(other)
      super || (other.class == self.class && other.id == self.id)
    end

  end
end
