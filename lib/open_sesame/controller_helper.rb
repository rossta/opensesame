module OpenSesame
  module ControllerHelper
    extend ActiveSupport::Concern

    def warden
      env['warden']
    end

    def authenticate_opensesame!
      warden.authenticate!(:scope => :opensesame)
    end

    def current_opensesame_user
      warden.user(:scope => :opensesame)
    end

  end
end