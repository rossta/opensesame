module OpenSesame
  class ApplicationController < ActionController::Base
    unloadable
    include OpenSesame::ControllerHelper
  end
end
