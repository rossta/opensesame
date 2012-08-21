# encoding: utf-8
module OpenSesame
  module Failure
    class App
      def call(env)
        OpenSesame::SessionsController.action(:new).call(env)
      end
    end
  end
end