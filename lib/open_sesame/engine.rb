# encoding: utf-8

module OpenSesame
  class Engine < ::Rails::Engine
    isolate_namespace OpenSesame

    config.generators do |g|
      g.test_framework :rspec, :view_specs => false
    end

    ActiveSupport.on_load(:action_controller) do
      include OpenSesame::Helpers::ControllerHelper
    end

    ActiveSupport.on_load(:action_view) do
      include OpenSesame::Helpers::ViewHelper
    end

    initializer "openseseame precompile" do |app|
      app.config.assets.precompile += ['open_sesame/opensesame.css']
    end

    initializer "opensesame.middleware", :after => :load_config_initializers do |app|
      if OpenSesame.enabled?
        require 'open_sesame/github_warden'
        app.config.middleware.use OpenSesame::GithubAuth,
          OpenSesame.github_application[:id],
          OpenSesame.github_application[:secret],
          :path_prefix => OpenSesame.mount_prefix

        if defined?(Devise)
          Devise.setup do |config|
            config.warden do |manager|
              manager.default_strategies(:opensesame_github, :scope => :opensesame)
              manager.failure_app = OpenSesame::Failure::DeviseApp.new
            end
          end
        else
          app.config.middleware.use ::Warden::Manager do |manager|
            manager.default_strategies(:opensesame_github, :scope => :opensesame)
            manager.failure_app = OpenSesame::Failure::App.new
          end
        end
      end

    end
  end
end
