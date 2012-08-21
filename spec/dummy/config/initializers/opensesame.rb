require "opensesame"

OpenSesame.configure do |config|
  config.organization 'challengepost'
  config.mounted_at   '/opensesame'
  config.github       'github_client_id', 'github_client_secret'
end