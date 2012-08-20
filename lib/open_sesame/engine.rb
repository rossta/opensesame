# encoding: utf-8
require 'warden'
require 'open_sesame/warden_strategy'

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

    initializer "opensesame.middleware", :after => :load_config_initializers do |app|
      app.config.assets.precompile += ['opensesame.css']

      OpenSesame.configuration.validate!

      app.config.middleware.use OpenSesame::AuthApp,
        :client_id => OpenSesame.configuration.client_id,
        :client_secret => OpenSesame.configuration.client_secret

      if defined?(Devise)
        Devise.setup do |config|
          config.warden do |manager|
            manager.default_strategies(:opensesame, :scope => :opensesame)
            manager.failure_app = OpenSesame::FailureApp.new
          end
        end
      else
        app.config.middleware.use ::Warden::Manager do |manager|
          manager.default_strategies(:opensesame, :scope => :opensesame)
          manager.failure_app = lambda { |env| OpenSesame::SessionsController.action(:new).call(env)}
        end
      end

    end
  end
end
