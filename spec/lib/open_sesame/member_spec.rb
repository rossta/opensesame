require 'spec_helper'

describe OpenSesame::Member, :vcr, :record => :new_episodes do
  ROSSTA_GITHUB_ID = 11673

  describe "self.find" do
    it "retrieves attributes from github" do
      member = OpenSesame::Member.find(ROSSTA_GITHUB_ID)
      member.should be_a(OpenSesame::Member)
      member.id.should == ROSSTA_GITHUB_ID
      member.login.should == 'rossta'
    end
  end

  describe "warden serialization" do
    let(:member) { OpenSesame::Member.find(ROSSTA_GITHUB_ID) }

    it "serialize_into_session returns given member.id in array" do
      OpenSesame::Member.serialize_into_session(member).should eq([ROSSTA_GITHUB_ID])
    end

    it "serialize_from_session returns member from given member id" do
      OpenSesame::Member.serialize_from_session(ROSSTA_GITHUB_ID).should eq(member)
    end
  end

end