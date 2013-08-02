# encoding: utf-8
module OpenSesame
  module Helpers::ControllerHelper
    extend ActiveSupport::Concern

    def warden
      env['warden']
    end

    def authenticate_opensesame!
      warden.authenticate!(:scope => :opensesame) unless current_opensesame_user
    end

    def current_opensesame_user
      warden.user(:scope => :opensesame)
    end

  end
end
