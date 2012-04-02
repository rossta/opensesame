module OpenSesame
  class SessionsController < ApplicationController
    unloadable

    skip_before_filter :authenticate_opensesame!
    skip_authorization_check if defined?(CanCan)

    def new
      flash.now[:notice] = warden.message if warden.message
      render :layout => 'open_sesame/application'
    end

    def create
      warden.authenticate!(:scope => :opensesame)
      flash[:success] = "Welcome!"
      redirect_to main_app.root_url
    end

    def destroy
      warden.logout(:opensesame)
      flash[:notice] = "Logged out!"
      redirect_to main_app.root_url
    end

    def failure
      raise params.inspect
    end

  end
end
