require "opensesame"

app_id = ENV['SESAMESTREET_APP_ID']
secret = ENV['SESAMESTREET_SECRET']

if app_id.nil?
  puts "Setting app_id to dummy string"
  app_id = 'dummy_app_id'
end

if secret.nil?
  puts "Setting secret to dummy string"
  secret = 'dummy_secret'
end

OpenSesame.configure do |config|
  config.organization 'challengepost'
  config.provider     'sesamestreet'
  config.mounted_at   '/opensesame'
  config.client       app_id, secret
end