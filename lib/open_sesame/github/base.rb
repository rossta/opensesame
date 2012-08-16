# encoding: utf-8

module OpenSesame::Github
  class Base
    # Public: Define readers from attributes hash
    #
    # symbol(s) - Method name
    #
    # Examples
    #
    #   lazy_attr_reader :id, :login
    #
    def self.lazy_attr_reader(*attrs)
      attrs.each do |attribute|
        class_eval do
          define_method(attribute) do
            @attributes[attribute.to_s] || @attributes[attribute] # allow string or symbol access
          end
        end
      end
    end

    attr_reader :attributes

    # Public: Instantiate a new Github::TeamMember from api attributes.
    #
    # attributes  - hash of api github team member attributes
    #
    # Examples
    #
    #   Github::TeamMember.new(
    #     "gravatar_id"=>"f009205a899da22248cca0b772aec9c9",
    #     "url"=>"https://api.github.com/users/defunkt",
    #     "avatar_url"=>"https://secure.gravatar.com/avatar/abcd1234.png",
    #     "id"=>2,
    #     "login"=>"defunkt"
    #    )
    #   # => <Github::TeamMember>
    #
    # Returns new Github::TeamMember.
    def initialize(attributes = {})
      @attributes = attributes
      yield self if block_given?
    end

    def ==(other)
      super || (other.class == self.class && other.id == self.id)
    end

    def get(*args)
      OpenSesame::Github.api.get(*args)
    end
  end
end