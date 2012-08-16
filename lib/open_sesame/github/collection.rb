# encoding: utf-8

module OpenSesame::Github
  class Collection < Base
    include Enumerable

    attr_accessor :url, :member_class

    def members
      @members ||= []
    end

    def find(id)
      members.detect { |member| member.id == id }
    end

    def fetch
      reset(get(url))
    end

    def reset(member_attrs)
      @members = [].tap do |member_set|
        member_attrs.map do |attrs|
          member_set << member_class.new(attrs)
        end
      end
    end

    def each(&block)
      members.each(&block)
    end

    def size
      members.size
    end
  end
end