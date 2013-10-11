# encoding: utf-8
require 'devise'
module OpenSesame
  module Failure
    class DeviseApp < ::Devise::Delegator

      def call(env)
        if (env['warden.options'] && (scope = env["warden.options"][:scope]) && scope == :opensesame)
          OpenSesame::SessionsController.action(:new).call(env)
        else
          super
        end
      end

    end
  end
end
