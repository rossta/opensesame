require 'spec_helper'

describe "Session", :vcr, :record => :new_episodes, :type => :feature do
  context "successful login" do
    before { setup_for_github_login }

    it "enforces opensesame login" do
      visit root_path
      within("#opensesame-session") do
        page.should have_content("Login")
        click_link "github"
      end

      page.should have_content "Welcome Home"
    end

    describe "auto login" do
      before { OpenSesame.stub(:auto_access_provider => 'github') }

      it "allows auto login" do
        visit root_path
        page.should have_content "Welcome Home"
      end

      it "skips auto login if just logged out" do
        visit root_path

        click_link "Logout"

        page.should_not have_content "Welcome Home"
        page.should have_content "Login"

        visit root_path  # auto login now works on refresh
        page.should have_content "Welcome Home"
        page.should_not have_content "Login"
      end
    end
  end

  it "tries auto login and ends up on opensesame page after failure" do
    setup_for_github_login(id: "123", login: "rickybobby")
    visit root_path
    page.should have_content "Login"
    page.should_not have_content "Welcome Home"
  end

end
