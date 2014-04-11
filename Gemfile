source "http://rubygems.org"

gemspec

gem "jquery-rails"

rails_version = ENV.fetch('RAILS_VERSION') { 'default' }
case rails_version
when "default"
  "~> 3.2"
else
  "~> #{rails_version}"
end

devise_version = ENV.fetch('DEVISE_VERSION') { 'ignore' }
case devise_version
when 'ignore'
  # don't include
else
  gem 'devise', "~> #{devise_version}"
end

gem "pry"
gem "pry-debugger"
