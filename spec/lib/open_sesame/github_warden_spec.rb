require 'spec_helper'

describe OpenSesame::GithubWarden do

  let(:strategy) { OpenSesame::GithubWarden.new(@env_with_params) }

  it "is not valid without omniauth hash" do
    @env_with_params = env_with_params("/", {}, 'omniauth.auth' => nil)
    strategy.valid?.should be_false
  end

  it "is not valid without github provider in omniauth hash" do
    @env_with_params = env_with_params("/", {}, 'omniauth.auth' => {})
    strategy.valid?.should be_false
  end

  it "is valid with github provider in omniauth hash" do
    @env_with_params = env_with_params("/", {}, 'omniauth.auth' => { "provider" => "github" })
    strategy.valid?.should be_true
  end

  it "returns omniauth auth_hash" do
    @env_with_params = env_with_params("/", {}, 'omniauth.auth' => { "provider" => "github" })
    strategy.auth_hash.should eq("provider" => "github")
  end

  it "authenticates successfully when OpenSesame::Member is found" do
    @env_with_params = env_with_params("/", {}, 'omniauth.auth' => { "provider" => "github", "uid" => "123" })

    OpenSesame::Member.should_receive(:find).with("123").and_return(OpenSesame::Member.new(:id => "123"))
    strategy.authenticate!
    strategy.result.should == :success
  end

  it "fails authentication when OpenSesame::Member is not found" do
    @env_with_params = env_with_params("/", {}, 'omniauth.auth' => { "provider" => "github", "uid" => "123" })
    OpenSesame::Member.should_receive(:find).with("123").and_return(nil)

    strategy.authenticate!
    strategy.result.should == :failure
    strategy.message.should == 'Sorry, you do not have access'
  end

end