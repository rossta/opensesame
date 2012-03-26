require 'opensesame-github'

module OpenSesame
  class Engine < ::Rails::Engine
    isolate_namespace OpenSesame

    config.generators do |g|
      g.test_framework :rspec, :view_specs => false
    end

    ActiveSupport.on_load(:action_controller) do
      include OpenSesame::ControllerHelper
    end

    ActiveSupport.on_load(:action_view) do
      include OpenSesame::ViewHelper
    end

    initializer "gardenwall.middleware", :after => :load_config_initializers do |app|
      OpenSesame.configuration.validate!

      OpenSesame::Github.organization_name = OpenSesame.organization_name

      middleware.use OmniAuth::Strategies::GitHub, OpenSesame.github_client[:id], OpenSesame.github_client[:secret]

      app.config.middleware.use Warden::Manager do |manager|
        manager.scope_defaults :opensesame, :strategies => [:opensesame_github]
        manager.failure_app = lambda { |env| OpenSesame::SessionsController.action(:new).call(env) }
      end

    end
  end
end
