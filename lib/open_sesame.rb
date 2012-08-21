module OpenSesame
  extend self

  autoload :Configuration, 'open_sesame/configuration'
  autoload :AuthApp, 'open_sesame/auth_app'
  autoload :AuthHash, 'open_sesame/auth_hash'
  autoload :WardenStrategy, 'open_sesame/warden_strategy'
  autoload :FailureApp, 'open_sesame/failure_app' if defined?(Devise)
  autoload :Github, 'open_sesame/github'

  module AuthStrategies
    autoload :Base, 'open_sesame/auth_strategies/base'
    autoload :Sesamestreet, 'open_sesame/auth_strategies/sesamestreet'
  end

  module Helpers
    autoload :ControllerHelper, 'open_sesame/helpers/controller_helper'
    autoload :ViewHelper, 'open_sesame/helpers/view_helper'
  end

  @to_configuration = Configuration::CONFIGURABLE_ATTRIBUTES + [:to => :configuration]
  delegate *@to_configuration
  delegate :enabled?, :mock_with, :strategy, :to => :configuration

  mattr_accessor :configuration
  @@configuration = Configuration.new

  def configure(&block)
    yield configuration
    configuration
  end
end

require "open_sesame/engine"