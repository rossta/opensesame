require 'spec_helper'

describe OpenSesame::GithubWarden do
  let(:strategy) { OpenSesame::GithubWarden.new(@env_with_params) }

  def auth_hash(auth = { "provider" => "github" })
    {
      'omniauth.auth' => OmniAuth::AuthHash.new(auth)
    }
  end

  it "is not valid without omniauth hash" do
    @env_with_params = env_with_params("/", {}, 'omniauth.auth' => nil)
    strategy.valid?.should be_false
  end

  it "is not valid without github provider in omniauth hash" do
    @env_with_params = env_with_params("/", {}, 'omniauth.auth' => {})
    strategy.valid?.should be_false
  end

  it "is valid with github provider in omniauth hash" do
    @env_with_params = env_with_params("/", {}, auth_hash)
    strategy.valid?.should be_true
  end

  it "returns omniauth auth_hash" do
    @env_with_params = env_with_params("/", {}, auth_hash)
    strategy.auth_hash.should eq("provider" => "github")
  end

  it "authenticates successfully when OpenSesame::Member is found" do
    @env_with_params = env_with_params("/", {}, auth_hash("provider" => "github", "uid" => "123", "info" => { "nickname" => "rickybobby" }))

    OpenSesame::Member.should_receive(:find).with("rickybobby").and_return(OpenSesame::Member.new(:login => "rickybobby"))
    strategy.authenticate!
    strategy.result.should == :success
  end

  it "fails authentication when OpenSesame::Member is not found" do
    @env_with_params = env_with_params("/", {}, auth_hash("provider" => "github", "uid" => "123", "info" => { "nickname" => "rickybobby" }))
    OpenSesame::Member.should_receive(:find).with("rickybobby").and_return(nil)

    strategy.authenticate!
    strategy.result.should == :failure
    strategy.message.should == 'Sorry, you do not have access'
  end

end
