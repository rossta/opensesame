# OpenSesame

OpenSesame is a [Warden](https://github.com/hassox/warden) strategy for providing "walled garden" authentication for access to Rack-based applications via Omniauth. For example, your company has internal apps and/or staging enviroments for multiple projects and you want something better than HTTP basic auth. The intent is protect the visibility of your app from the outside world.

Enter OpenSesame. To authenticate, OpenSesame currently uses Omniauth and the Github API to require that a user is both logged in to Github and a member of the configurable Github organization.

## Usage

In your Gemfile:

    $ gem "opensesame"

Register your application(s) with Github for OAuth access. For each application, you need a name, the site url,
and a callback for OAuth. The OmniAuth-Github OAuth strategy used under the hood will expect the callback at mount path + '/auth/github/callback'. So the development version of your client application might be registered as:

    Name: MyApp - local
    URL: http://localhost:3000
    Callback URL: http://localhost:3000/welcome/auth/github/callback

Configure OpenSesame:

```ruby
# Rails config/initializers/opensesame.rb or Sinatra app.rb

require 'opensesame'

OpenSesame.configure do |config|
  config.github       ENV['CAPITAN_GITHUB_KEY'], ENV['CAPITAN_GITHUB_SECRET']
  config.organization 'challengepost'
  config.mounted_at   '/welcome'
end
```

Mount OpenSesame in your Rails routes.rb:

```ruby
# Rails config/routes.rb

mount OpenSesame::Engine => "/welcome", :as => "opensesame"
```
