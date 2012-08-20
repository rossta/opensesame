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

  describe "#call" do
    it "sets env on each call" do
      env_1 = env_with_params('/first')
      env_2 = env_with_params('/second')
      auth_app.call(env_1)
      auth_app.env.should eq(env_1)

      auth_app.call(env_2)
      auth_app.env.should eq(env_2)
    end
  end

  describe "#request_call" do
    before do
      @params = { "foo" => 'bar', "legit" => 'param' }
    end

    it "sets query params on opensesame rack session" do
      auth_app.env = env_with_rack_session("/auth", @params)
      auth_app.request_call
      auth_app.env['rack.session']['opensesame.params'].should eq(@params)
    end

    it "sets the origin from params on rack session" do
      @params['origin'] = "/home"
      auth_app.env = env_with_rack_session("/auth", @params)
      auth_app.request_call
      auth_app.env['rack.session']['opensesame.origin'].should eq('/home')
    end

    it "sets the origin from HTTP_REFERER otherwise on rack session" do
      env = env_with_rack_session("/auth", @params, 'HTTP_REFERER' => '/home')
      auth_app.env = env
      auth_app.request_call
      auth_app.env['rack.session']['opensesame.origin'].should eq('/home')
    end

  end

  describe "#callback_call" do
    before do
      @params = { "foo" => 'bar', "legit" => 'param', 'origin' => '/home' }
      @env = env_with_rack_session("/auth", @params)
      auth_app.env = @env
      auth_app.request_call

      client = mock(OAuth2::Client)
      OAuth2::Client.stub!(:new => client)
      auth_code = mock(OAuth2::Strategy::AuthCode)
      access_token = mock(OAuth2::AccessToken,
        :expired? => false,
        :expires? => false,
        :refresh! => nil,
        :options => {},
        :token => "1234abcd"
      )
      access_token.stub!(:get).with('/api/me').and_return(mock("Response", :parsed => {}))
      auth_code.stub!(:get_token => access_token)
      client.stub!(:auth_code => auth_code)
    end

    it "sets query params on opensesame env from rack session following request_call" do
      auth_app.callback_call
      auth_app.env['opensesame.params'].should eq(@params)
    end

    it "sets the origin from params on env from rack session" do
      auth_app.callback_call
      auth_app.env['opensesame.origin'].should eq('/home')
    end

  end

end