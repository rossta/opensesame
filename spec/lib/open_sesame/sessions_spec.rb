require 'spec_helper'

describe "Session", :type => :request do

  context "successful login" do
    before { setup_for_opensesame_login }

    it "enforces opensesame login" do
      visit root_path
      within("#opensesame-session") do
        page.should have_content("Login")
        click_link "challengepost"
      end

      page.should have_content "Welcome Home"
    end

    it "allows auto login" do
      OpenSesame.stub!(:auto_access_provider).and_return('alibaba')
      visit root_path
      page.should have_content "Welcome Home"
    end

  end

  it "tries auto login and ends up on opensesame page after failure" do
    OpenSesame.stub!(:auto_access_provider).and_return('alibaba')
    visit root_path
    page.should have_content "Login"
    page.should_not have_content "Welcome Home"
  end

end