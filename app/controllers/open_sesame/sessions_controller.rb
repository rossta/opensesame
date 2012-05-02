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

    protected

    def attempt_auto_authenticate
      return unless attempt_auto_access?
      
      redirect_to identity_request_path(OpenSesame.auto_access_provider)
    end

    def attempt_auto_access?
      return false unless OpenSesame.auto_access_provider.present?
      attempts = session[:opensesame_auto_access_attempt].to_i
      session[:opensesame_auto_access_attempt] = attempts + 1
      attempts < 1
    end

    def clear_auto_attempt!
      session[:opensesame_auto_access_attempt] = nil
    end
  end
end
