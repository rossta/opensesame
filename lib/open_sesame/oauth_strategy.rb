# encoding: utf-8
module OpenSesame
  class AuthStrategy::Sesamestreet < AuthStrategy::Base
    def site
      if Rails.env.test? || Rails.env.development?
        'http://localhost:3001'
      else
        'https://sesamestreet.herokuapp.com'
      end
    end

    def name
      'sesamestreet'
    end
  end

end