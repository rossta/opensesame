require 'spec_helper'

describe OpenSesame::Github do

  it "has organization_name" do
    OpenSesame::Github.organization_name = 'challengepost'
    OpenSesame::Github.organization_name.should == 'challengepost'
  end
end