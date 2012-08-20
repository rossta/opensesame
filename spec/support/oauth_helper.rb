# encoding: utf-8
module OAuthHelper
  def setup_for_opensesame_login(options = {})
    OpenSesame.mock_with({
      "uid" => "1234",
      "provider" => "sesamestreet",
      "raw_info" => { "name" => "Bob" }
    }.merge(options))
  end
end

RSpec.configuration.send :include, OAuthHelper