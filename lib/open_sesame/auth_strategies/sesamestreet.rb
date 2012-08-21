# encoding: utf-8
module OpenSesame
  module AuthStrategies
    class Sesamestreet < OpenSesame::AuthStrategies::Base
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
end