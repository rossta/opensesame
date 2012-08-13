require "opensesame"

OpenSesame.configure do |config|
  config.organization 'challengepost'
  config.mounted_at   '/welcome'
  config.github       ENV['GITHUB_CLIENT_ID'], ENV['GITHUB_CLIENT_SECRET']
end