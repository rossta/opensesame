module OpenSesame
  extend self

  autoload :Configuration, 'open_sesame/configuration'
  autoload :ControllerHelper, 'open_sesame/controller_helper'
  autoload :ViewHelper, 'open_sesame/view_helper'
  autoload :AuthApp, 'open_sesame/auth_app'
  autoload :Strategy, 'open_sesame/strategy'
  autoload :FailureApp, 'open_sesame/failure_app' if defined?(Devise)
  autoload :Github, 'open_sesame/github'

  @to_configuration = Configuration::CONFIGURABLE_ATTRIBUTES + [:to => :configuration]
  delegate *@to_configuration
  delegate :enabled?, :to => :configuration

  mattr_accessor :configuration
  @@configuration = Configuration.new

  def configure(&block)
    yield configuration
    configuration
  end
end

require "open_sesame/engine"