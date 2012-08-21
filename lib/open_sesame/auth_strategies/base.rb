# encoding: utf-8
module OpenSesame
  module AuthStrategies
    class Base

      def name
        raise 'Subclass must implement'
      end

      def site
        raise 'Subclass must implement'
      end

      def authorize_url
      end

      def token_url
      end

      def client_options
        { :site => site }
      end

    end
  end
end