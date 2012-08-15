require 'warden'

module OpenSesame
  class Strategy < ::Warden::Strategies::Base
    attr_writer :organization

    def valid?
      auth_hash && auth_hash["provider"] == "sesamestreet"
    end

    def authenticate!
      if auth_hash["uid"].present?  # instantiate a OpenSesame::User
        success! auth_hash["uid"]
      else
        fail 'Sorry, you do not have access'
      end
    end

    def auth_hash
      request.env['opensesame.auth']
    end

  end

end

Warden::Strategies.add(:opensesame, OpenSesame::Strategy)