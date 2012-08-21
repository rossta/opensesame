require "opensesame"

app_id = ENV['GITHUB_APP_ID']
secret = ENV['GITHUB_SECRET']

if app_id.nil?
  puts "Setting app_id to dummy string"
  app_id = 'dummy_app_id'
end

if secret.nil?
  puts "Setting secret to dummy string"
  secret = 'dummy_secret'
end

OpenSesame.configure do |config|
  config.enable       true
  config.organization 'challengepost'
  config.mounted_at   '/opensesame'
  config.github       app_id, secret
end