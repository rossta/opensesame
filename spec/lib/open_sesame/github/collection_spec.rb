# encoding: utf-8
require 'spec_helper'

describe OpenSesame::Github::Collection do

  let(:collection) {
    OpenSesame::Github::Collection.new do |coll|
      coll.member_class = OpenSesame::Github::TeamMember
    end
  }

  before do
    @team_member_attributes = [
      {"id" => 2, "login" => "defunkt" },
      {"id" => 3, "login" => "mojombo" }
    ]
    collection.reset(@team_member_attributes)
  end

  it "should instantiate team members from given attributes" do
    collection.first.should be_a(OpenSesame::Github::TeamMember)
    collection.size.should == 2
  end

  describe "find" do
    it "should be able to find an existing id with valid id" do
      collection.find(2).should == OpenSesame::Github::TeamMember.new("id" => 2, "login" => "defunkt")
    end

    it "returns nil if no member with given id" do
      collection.find(1000).should be_nil
    end
  end

end