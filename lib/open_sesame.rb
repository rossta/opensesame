module OpenSesame
  extend self

  autoload :Configuration, 'open_sesame/configuration'
  autoload :ControllerHelper, 'open_sesame/controller_helper'
  autoload :ViewHelper, 'open_sesame/view_helper'

  delegate *Configuration::CONFIGURABLE_ATTRIBUTES, :to => :configuration

  mattr_accessor :configuration
  @@configuration = Configuration.new

  def configure(&block)
    yield configuration
    configuration
  end
end

require "open_sesame/engine"
