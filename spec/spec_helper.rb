# Configure Rails Envinronment
ENV["RAILS_ENV"] = "test"
require File.expand_path("../dummy/config/environment.rb",  __FILE__)

require 'rspec/rails'
require 'rspec/autorun'
require 'capybara/rspec'

ENGINE_RAILS_ROOT=File.join(File.dirname(__FILE__), '../')

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[File.join(ENGINE_RAILS_ROOT, "spec/support/**/*.rb")].each {|f| require f }

OpenSesame.configuration.test_mode = true

RSpec.configure do |config|
  config.use_transactional_fixtures = true
  config.infer_base_class_for_anonymous_controllers = false
end

module TestHelper
  def setup_for_opensesame_login(options = {})
    OpenSesame.configuration.mock_auth = {
      "uid" => "1234",
      "provider" => "alibaba"
    }.merge(options)
  end
end

RSpec.configuration.send :include, TestHelper
