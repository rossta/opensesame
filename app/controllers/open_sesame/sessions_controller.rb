module OpenSesame
  class SessionsController < OpenSesame::ApplicationController

    skip_before_action :authenticate_opensesame!, raise: false
    skip_authorization_check if defined?(CanCan)
    before_action :attempt_auto_authenticate, :only => :new
    after_action :clear_auto_attempt!, :only => :create

    def new
      if error_message
        flash.now[:notice] = error_message
      end
      render :layout => 'open_sesame/application'
    end

    def create
      login_opensesame
      redirect_to after_login_path
    end

    def destroy
      logout_opensesame
      redirect_to after_logout_path
    end

    def failure
      raise params.inspect
    end

    protected

    def error_message
      warden.message || env['omniauth.error'] || env['omniauth.error.type']
    end

    def attempt_auto_authenticate
      return unless attempt_auto_access?

      redirect_to identity_request_path(OpenSesame.auto_access_provider)
    end

    def attempt_auto_access?
      return false if just_logged_out?
      return false unless OpenSesame.auto_access_provider.present?
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

    def after_login_path
      OpenSesame.after_login_path || main_app.root_url
    end

    def after_logout_path
      OpenSesame.after_logout_path || main_app.root_url
    end

  end
end
