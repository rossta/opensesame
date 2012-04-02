require 'devise'
module OpenSesame
  class FailureApp < Devise::Delegator

    def call(env)
      if (env['warden.options'] && (scope = env["warden.options"][:scope]) && scope == :opensesame)
        OpenSesame::SessionsController.action(:new).call(env)
      else
        super
      end
    end

  end
end