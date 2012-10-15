require "opensesame"

app_id = ENV['GITHUB_APP_ID']
secret = ENV['GITHUB_SECRET']
login = ENV['GITHUB_LOGIN']
oauth_token = ENV['GITHUB_OAUTH_TOKEN']

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
  config.github_application_credentials app_id, secret
  if ENV['GITHUB_LOGIN'] && ENV['GITHUB_OAUTH_TOKEN']
    config.github_account_credentials ENV['GITHUB_LOGIN'], ENV['GITHUB_OAUTH_TOKEN']
  end
end
