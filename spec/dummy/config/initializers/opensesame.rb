require "opensesame"

OpenSesame.configure do |config|
  config.organization 'challengepost'
  config.mounted_at   '/opensesame'
  config.client       ENV['SESAMESTREET_APP_ID'], ENV['SESAMESTREET_SECRET']
end