require 'spec_helper'

describe OpenSesame::Member, :vcr, :record => :new_episodes do

  let(:github_login) { user_attributes[:login] }
  let(:github_id) { user_attributes[:id] }

  describe "self.find" do
    it "retrieves attributes from github" do
      member = OpenSesame::Member.find(github_login)
      member.should be_a(OpenSesame::Member)
      member.login.should == 'rossta'
    end

    it "returns nil if no github member found" do
      nonexisting_id = -1
      member = OpenSesame::Member.find(nonexisting_id)
      member.should be_nil
    end
  end

  describe "warden serialization" do
    let(:member) { OpenSesame::Member.find(github_login) }

    it "serialize_into_session returns given member.id in array" do
      OpenSesame::Member.serialize_into_session(member).should eq([github_login])
    end

    it "serialize_from_session returns member from given member id" do
      OpenSesame::Member.serialize_into_session(member)
      OpenSesame::Member.serialize_from_session(github_login).should eq(member)
    end
  end

end
