require 'spec_helper'

describe "Session", :type => :request do

  context "successful login" do
    before { setup_for_github_login } # provided by opensesame-github/capybara

    it "enforces opensesame login" do
      visit root_path
      within("#opensesame-session") do
        page.should have_content("Login")
        click_link "github"
      end

      page.should have_content "Welcome Home"
    end

    it "allows auto login" do
      OpenSesame.stub!(:auto_access_provider).and_return('github')
      visit root_path
      page.should have_content "Welcome Home"
    end

  end

  it "tries auto login and ends up on opensesame page after failure" do
    OpenSesame.stub!(:auto_access_provider).and_return('github')
    visit root_path
    page.should have_content "Login"
    page.should_not have_content "Welcome Home"
  end

end