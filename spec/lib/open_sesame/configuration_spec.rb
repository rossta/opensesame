require 'spec_helper'

describe OpenSesame::Configuration do

  let(:configuration) { OpenSesame::Configuration.new }
  subject { configuration }

  it "organization sets organzation name" do
    configuration.organization "challengepost"
    configuration.organization_name.should == "challengepost"
  end

  it "github sets github client credentials" do
    configuration.github "client_id", "client_secret"
    configuration.github_client[:id].should == "client_id"
    configuration.github_client[:secret].should == "client_secret"
  end

  it "mounted_at sets mount_prefix" do
    configuration.mounted_at "/foobar"
    configuration.mount_prefix.should == "/foobar"
  end

  describe "valid?" do
    it "false when values not set" do
      configuration.organization "challengepost"
      configuration.should_not be_valid

      configuration.organization_name = nil
      configuration.github "client_id", "client_secret"
      configuration.should_not be_valid

      configuration.github_client = nil
      configuration.mounted_at "/foobar"
      configuration.should_not be_valid
    end

    it "true when all values set" do
      configuration.organization "challengepost"
      configuration.github "client_id", "client_secret"
      configuration.mounted_at "/foobar"
      configuration.should be_valid
    end
  end

  describe "validate!" do
    it { lambda { configuration.validate! }.should raise_error(OpenSesame::ConfigurationError) }

    it "succeeds when valid" do
      configuration.organization "challengepost"
      configuration.github "client_id", "client_secret"
      configuration.mounted_at "/foobar"
      configuration.should be_valid

      configuration.validate!.should be_true
    end
  end
end