module OpenSesame
  class SessionsController < ApplicationController
    unloadable

    skip_before_filter :authenticate_opensesame!

    def new
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
