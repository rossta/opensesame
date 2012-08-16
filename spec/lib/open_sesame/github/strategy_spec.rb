# encoding: utf-8
require 'spec_helper'

describe OpenSesame::Github::Strategy do

  let(:strategy) { OpenSesame::Github::Strategy.new(@env) }

  before do
    @env = env_with_params
  end

  it "should be a warden strategy" do
    OpenSesame::Github::Strategy.ancestors.should include(Warden::Strategies::Base)
  end

  it "is valid when github is provider in request env omniauth key" do
    @env['omniauth.auth'] = { "provider" => "github" }
    strategy.should be_valid
  end

  it "is not valid when provider is other in request env omniauth key" do
    @env['omniauth.auth'] = { "provider" => "another" }
    strategy.should_not be_valid
  end

  it "is not valid when omniauth key is missing in request env" do
    strategy.should_not be_valid
  end

  it "can have a scope" do
    strategy = OpenSesame::Github::Strategy.new(@env, :team_member)
    strategy.scope.should == :team_member
  end

  describe "authenticate!" do
    let(:organization) { OpenSesame::Github::Organization.new }
    let(:team_members) { OpenSesame::Github::Collection.new }

    before do
      @env['omniauth.auth'] = { "provider" => "github", "uid" => 123 }

      team_members.stub!(:find => nil)
      organization.team_members = team_members
      strategy.organization = organization
    end

    it "success" do
      team_members.should_receive(:find).with(123).and_return(:team_member)
      strategy._run!
      strategy.user.should == :team_member
      strategy.result.should == :success
    end

    it "fail" do
      team_members.should_receive(:find).with(123).and_return(nil)
      strategy._run!
      strategy.user.should be_nil
      strategy.result.should == :failure
    end
  end

  describe "organization" do
    it "should initialize based on configuration" do
      OpenSesame::Github.organization_name = 'apple'
      strategy.organization.should == OpenSesame::Github::Organization.new(:name => 'apple')
    end

  end
end