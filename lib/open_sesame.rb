module OpenSesame
  extend self

  autoload :Configuration, 'open_sesame/configuration'
  autoload :GithubAuth, 'open_sesame/github_auth'
  autoload :GithubWarden, 'open_sesame/github_warden'
  autoload :FailureApp, 'open_sesame/failure_app'
  autoload :Member, 'open_sesame/member'

  module Helpers
    autoload :ControllerHelper, 'open_sesame/helpers/controller_helper'
    autoload :ViewHelper, 'open_sesame/helpers/view_helper'
  end

  module Failure
    autoload :App, 'open_sesame/failure/app'
    autoload :DeviseApp, 'open_sesame/failure/devise_app'
  end

  @to_configuration = Configuration::CONFIGURABLE_ATTRIBUTES + [:to => :configuration]
  delegate *@to_configuration
  delegate :enabled?, :to => :configuration

  mattr_accessor :configuration
  @@configuration = Configuration.new

  def configure(&block)
    configuration.enable! # defaults to true
    yield configuration
    configuration
  end

  def logger
    @logger ||= defined?(Rails) ? Rails.logger : Logger.new(STDOUT)
  end
end

require "open_sesame/engine" if defined?(Rails)
