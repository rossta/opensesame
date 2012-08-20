module OpenSesame
  extend self

  autoload :Configuration, 'open_sesame/configuration'
  autoload :AuthApp, 'open_sesame/auth_app'
  autoload :AuthHash, 'open_sesame/auth_hash'
  autoload :Strategy, 'open_sesame/strategy'
  autoload :FailureApp, 'open_sesame/failure_app' if defined?(Devise)
  autoload :Github, 'open_sesame/github'

  module Helpers
    autoload :ControllerHelper, 'open_sesame/helpers/controller_helper'
    autoload :ViewHelper, 'open_sesame/helpers/view_helper'
  end

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