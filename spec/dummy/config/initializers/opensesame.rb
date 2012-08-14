require "opensesame"

OpenSesame.configure do |config|
  config.organization 'challengepost'
  config.mounted_at   '/opensesame'
  config.client       ENV['ALIBABA_CLIENT_ID'], ENV['ALIBABA_CLIENT_SECRET']
end