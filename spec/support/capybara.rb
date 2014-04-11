require 'open_sesame/member'
require 'omniauth'
module CapybaraHelper

  def setup_for_github_login(attributes = user_attributes)
    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new \
      "provider" => 'github',
      "uid" => attributes[:id],
      "info" => { "nickname" => attributes[:login] }
  end

  def login_with_github
    setup_for_github_login
    visit root_path
    click_link 'github'
  end
end

module GeneralHelper

  def user_attributes
    { :login => 'rossta', :id => 11673 }
  end

end

RSpec.configuration.send :include, GeneralHelper
RSpec.configuration.send :include, CapybaraHelper, :type => :feature
