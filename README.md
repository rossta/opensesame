# OpenSesame

[![Build Status](https://secure.travis-ci.org/rossta/opensesame.png)](http://travis-ci.org/rossta/opensesame)
[![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/rossta/opensesame)

OpenSesame is a [Warden](https://github.com/hassox/warden) strategy for providing "walled garden" authentication for access to Rack-based applications via Omniauth. The intent is protect the visibility of your app from the outside world. For example, your company has internal apps and/or staging enviroments for multiple projects and you want something better than HTTP basic auth.

Enter OpenSesame. To authenticate, OpenSesame currently uses Omniauth and the Github API to require that a user is both logged in to Github and a member of the Github organization for which OpenSesame is configured.

## Usage

In your Gemfile:

```ruby
gem "opensesame"
```

Register your application(s) with Github for OAuth access. For each application, you need a name, the site url,
and a callback for OAuth. The OmniAuth-Github OAuth strategy used under the hood will expect the callback at mount path + '/github/callback'. So the development version of your client application might be registered as:

    Name: MyApp - local
    URL: http://localhost:3000
    Callback URL: http://localhost:3000/opensesame/github/callback

Configure OpenSesame:

```ruby
# Rails config/initializers/opensesame.rb

require 'opensesame'

OpenSesame.configure do |config|
  config.enable       Rails.env.staging?
  config.github ENV['GITHUB_APP_ID'], ENV['GITHUB_SECRET']
  config.organization 'challengepost'
  config.mounted_at   '/opensesame'

  config.redirect_to '/path' # Set redirect to for both login and logout
  config.redirect_after_login '/path'
  config.redirect_after_logout '/path'
end
```

Mount OpenSesame in your Rails routes:

```ruby
# Rails config/routes.rb
mount OpenSesame::Engine => OpenSesame.mount_prefix
```

Place the following in your application_controller:

```ruby
before_action :authenticate_opensesame!
```
