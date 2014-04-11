source "http://rubygems.org"

gemspec

gem "jquery-rails"

devise_version = ENV.fetch('DEVISE_VERSION') { 'ignore' }
case devise_version
when 'ignore'
  # don't include
else
  gem 'devise', "~> #{devise_version}"
end

gem "pry"
gem "pry-debugger"
