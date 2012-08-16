# encoding: utf-8
require 'spec_helper'

describe OpenSesame::Github::TeamMember do

  describe "==" do
    it "is true based on identity" do
      OpenSesame::Github::TeamMember.new("id" => 2).should == OpenSesame::Github::TeamMember.new("id" => 2)
    end

    it "is false with mismatched ids" do
      OpenSesame::Github::TeamMember.new("id" => 2).should_not == OpenSesame::Github::TeamMember.new("id" => 3)
    end

    it "is false with mismatched classes" do
      OpenSesame::Github::TeamMember.new("id" => 2).should_not == OpenSesame::Github::Organization.new("id" => 2)
    end
  end
end