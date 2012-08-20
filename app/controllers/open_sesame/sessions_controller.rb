module OpenSesame
  class SessionsController < OpenSesame::ApplicationController

    skip_before_filter :authenticate_opensesame!
    skip_authorization_check if defined?(CanCan)
    before_filter :attempt_auto_authenticate, :only => :new
    after_filter :clear_auto_attempt!, :only => :create

    def new
      if warden.message
        flash.now[:notice] = warden.message
      end
      render :layout => 'open_sesame/application'
    end

    def create
      login_opensesame
      redirect_to main_app.root_url
    end

    def destroy
      logout_opensesame
      redirect_to main_app.root_url
    end

    def failure
      raise params.inspect
    end

    protected

    def attempt_auto_authenticate
      return unless attempt_auto_access?
      redirect_to auth_request_path(OpenSesame.provider_name)
    end

    def attempt_auto_access?
      return false if just_logged_out?
      return false unless OpenSesame.auto_access
      attempts = session[:opensesame_auto_access_attempt].to_i
      session[:opensesame_auto_access_attempt] = attempts + 1
      attempts < 1
    end

    def just_logged_out?
      !!session[:opensesame_logged_out].tap do
        session[:opensesame_logged_out] = nil
      end
    end

    def clear_auto_attempt!
      session[:opensesame_auto_access_attempt] = nil
    end

    def login_opensesame
      warden.authenticate!(:scope => :opensesame)
      flash[:success] = "Welcome!"
    end

    def logout_opensesame
      warden.logout(:opensesame)
      session[:opensesame_logged_out] = 1
      flash[:notice] = "Logged out!"
    end

  end
end
