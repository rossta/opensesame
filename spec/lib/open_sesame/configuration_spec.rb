require 'spec_helper'

describe OpenSesame::Configuration do

  let(:configuration) { OpenSesame::Configuration.new }
  subject { configuration }

  it "organization sets organzation name" do
    configuration.organization "challengepost"
    configuration.organization_name.should == "challengepost"
  end

  it "sets client credentials" do
    configuration.client "client_id", "client_secret"
    configuration.client_id.should == "client_id"
    configuration.client_secret.should == "client_secret"
  end

  it "mounted_at sets mount_prefix" do
    configuration.mounted_at "/foobar"
    configuration.mount_prefix.should == "/foobar"
  end

  it "auto_access sets provider to attempt auto login" do
    configuration.auto_login "alibaba"
    configuration.auto_access_provider.should == "alibaba"
  end

  describe "valid?" do
    it "false when values not set" do
      configuration.organization "challengepost"
      configuration.should_not be_valid

      configuration.organization_name = nil
      configuration.client "client_id", "client_secret"
      configuration.should_not be_valid

      configuration.client_id = nil
      configuration.client_secret = nil
      configuration.mounted_at "/foobar"
      configuration.should_not be_valid
    end

    it "true when all values set" do
      configuration.organization "challengepost"
      configuration.client "client_id", "client_secret"
      configuration.mounted_at "/foobar"
      configuration.should be_valid
    end
  end

  describe "validate!" do
    it { lambda { configuration.validate! }.should raise_error(OpenSesame::ConfigurationError) }

    it "succeeds when valid" do
      configuration.organization "challengepost"
      configuration.client "client_id", "client_secret"
      configuration.mounted_at "/foobar"
      configuration.should be_valid

      configuration.validate!.should be_true
    end
  end

  describe "enabled?" do
    let(:conditional) { mock('conditional', :true? => true) }

    it { configuration.enabled?.should be_false }

    it "true if enabled!" do
      configuration.enable!
      configuration.should be_enabled
    end

    it "false if disabled" do
      configuration.disable!
      configuration.should_not be_enabled
    end

    it "false if enable_if clause is false" do
      conditional.stub!(:true?).and_return(false)
      configuration.enable_if conditional.true?
      configuration.should_not be_enabled
    end

    it "true if enable_if clause is true" do
      conditional.stub!(:true?).and_return(true)
      configuration.enable_if conditional.true?
      configuration.should be_enabled
    end

    it "true if enable_if clause is false but then enabled!" do
      conditional.stub!(:true?).and_return(false)
      configuration.enable_if conditional.true?
      configuration.enable!
      configuration.should be_enabled
    end

    it "false if enable_if clause is true but then disabled!" do
      conditional.stub!(:true?).and_return(true)
      configuration.enable_if conditional.true?
      configuration.disable!
      configuration.should_not be_enabled
    end

    it "false if enabled! then supplied with enable_if clause that is false" do
      configuration.enable!
      conditional.stub!(:true?).and_return(false)
      configuration.enable_if conditional.true?
      configuration.should_not be_enabled
    end

    it "true if disabled! then supplied with enable_if clause that is true" do
      configuration.disable!
      conditional.stub!(:true?).and_return(true)
      configuration.enable_if conditional.true?
      configuration.should be_enabled
    end
  end
end