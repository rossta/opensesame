require 'spec_helper'

describe OpenSesame::AuthApp do 
  let(:auth_app) { OpenSesame::AuthApp.new(success_app, \
     :client_id => 'client_id',
     :client_secret => 'client_secret'
    )}

  describe "#client" do
    it "is an OAuth2::Client" do
      auth_app.client.should be_a(OAuth2::Client)    
    end

    it "contains given client_id and client_secret" do
      auth_app.client.id.should eq("client_id")
      auth_app.client.secret.should eq("client_secret")
    end
  end

  describe "#provider" do
    it { auth_app.provider.should eq('sesamestreet')}
  end

  describe "#request_path" do
    it "should returns <mount_prefix>/auth/request" do
      auth_app.request_path.should eq('/opensesame/auth/request')
    end
  end

  describe "on_path?" do
    before(:each) do
      auth_app.call(env_with_params("/auth/request/success"))
    end
   
    it "is true if current_path matches given path" do
      auth_app.on_path?("/auth/request/success").should be_true
    end

    it "is false if current_path matches given path" do
      auth_app.on_path?("/").should be_false
    end
  end
end