require 'octokit'

module CapybaraHelper

  def setup_for_github_login(user = test_user)
    OmniAuth.config.mock_auth[:github] = {
      "provider" => 'github',
      "uid" => user.id,
      "nickname" => user.login
    }
  end

  def test_user
    Octokit.user('rossta')
  end

  def login_with_github
    setup_for_github_login
    visit root_path
    click_link 'github'
  end

end

RSpec.configuration.send :include, CapybaraHelper, :type => :request
