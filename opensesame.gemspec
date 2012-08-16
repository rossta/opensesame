$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "open_sesame/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "opensesame"
  s.version     = OpenSesame::VERSION
  s.authors     = ["Ross Kaffenberger"]
  s.email       = ["rosskaff@gmail.com"]
  s.homepage    = "https://github.com/rossta/opensesame"
  s.summary     = "Rails engine for authenticating internal applications and private-access products"
  s.description = "Rails engine for authenticating internal applications and private-access products"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rails", "~> 3.2"
  s.add_dependency "oauth2"
  s.add_dependency "warden"
  s.add_dependency "faraday", '~> 0.8'
  s.add_dependency "faraday_middleware"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec-rails", "~> 2.9.0"
  s.add_development_dependency "capybara"
  s.add_development_dependency "launchy"
  s.add_development_dependency "pry"
  s.add_development_dependency "pry-nav"
  s.add_development_dependency "vcr"
  s.add_development_dependency "fakeweb"
end
