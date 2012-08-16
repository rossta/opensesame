# encoding: utf-8
module OAuthHelper
  def setup_for_opensesame_login(options = {})
    OpenSesame.configuration.mock_auth = {
      "uid" => "1234",
      "provider" => "sesamestreet"
    }.merge(options)
  end
end

RSpec.configuration.send :include, OAuthHelper