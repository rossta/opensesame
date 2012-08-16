# encoding: utf-8
require 'spec_helper'

describe OpenSesame::Github::Organization  do

  let(:organization) { OpenSesame::Github::Organization.new(:name => 'challengepost') }


  it "should initialize with organization name" do
    organization.name.should == 'challengepost'
  end

  context "team_members stubbed" do
    let(:team_members) { OpenSesame::Github::Collection.new { |c| c.member_class = OpenSesame::Github::TeamMember } }

    before do
      @attribute_set = [ { "id" => 1 }, { "id" => 2 } ]
      team_members.stub!(:refresh)
      team_members.reset(@attribute_set)
      organization.team_members = team_members
    end

    it { organization.team_member_ids.should == [1, 2] }
    it { organization.team_member_attributes.should == @attribute_set }

    describe "team_member?" do
      it "is true if has team member with given team member id" do
        organization.team_member?(1).should be_true
      end

      it "is true if has team member with given team member id" do
        organization.team_member?(-1).should be_false
      end
    end

    it "fetch_team_members" do
      team_members.should_receive(:fetch)
      organization.fetch_team_members
    end

    it "find_team_member" do
      team_members.should_receive(:find).with(1)
      organization.find_team_member(1)
    end

  end

  context "team_members via api" do
    describe "team_members", :vcr, :record => :new_episodes, :cassette => 'team_members' do
      it "should fetch team_members via api" do
        organization.team_members.should be_a(OpenSesame::Github::Collection)
        organization.team_members.first.should be_a(OpenSesame::Github::TeamMember)
      end
    end
  end

  describe "==" do
    it "equal for same name" do
      OpenSesame::Github::Organization.new(:name => "apple") == OpenSesame::Github::Organization.new(:name => "apple")
    end

    it "not equal for different name" do
      OpenSesame::Github::Organization.new(:name => "apple") == OpenSesame::Github::Organization.new(:name => "microsoft")
    end
  end
end