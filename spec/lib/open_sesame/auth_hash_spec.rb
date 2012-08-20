require 'spec_helper'

describe OpenSesame::AuthHash do

  describe "#to_hash" do
    let(:raw_info) { { 'id' => '1234' } }
    let(:access_token) {
      mock OAuth2::AccessToken, \
        :expired? => false,
        :expires? => false,
        :refresh! => nil,
        :options => {},
        :refresh_token => nil,
        :token => "1234abcd"
    }

    let(:auth_hash) { OpenSesame::AuthHash.new(access_token, :provider => 'sesamestreet') }

    before do
      access_token.stub!(:get).with('/api/me').and_return(mock("Response", :parsed => raw_info))
    end

    describe "#valid?" do
      it "is valid when uid? && provider? && info? && info name?" do
        auth_hash['uid'] = "123"
        auth_hash['provider'] = 'sesamestreet'
        auth_hash['info'] = { "name" => "Bob" }
        auth_hash.valid?.should be_true
      end

      context "invalid" do
        it "has no uid" do
          auth_hash['uid'] = nil
          auth_hash.valid?.should be_false
        end

        it "has no provider" do
          auth_hash['provider'] = nil
          auth_hash.valid?.should be_false
        end

        it "has no info" do
          auth_hash['info'] = nil
          auth_hash.valid?.should be_false
        end

        it "has no name in info" do
          auth_hash['info'] = {}
          auth_hash.valid?.should be_false
        end
      end

    end

    # main
    # {
    #   'uid' => uid,
    #   'provider' => provider,
    #   'info' => info,
    #   'credentials' => credentials,
    #   'extra' => extra
    # }
    it "returns hash with keys: uid, provider, info, credentials, extra" do
      auth_hash['uid'].should be_present
      auth_hash['provider'].should be_present
      auth_hash['info'].should be_present
      auth_hash['credentials'].should be_present
      auth_hash['extra'].should be_present
    end

    # uid: id
    it "has uid from id in raw_info" do
      auth_hash['uid'].should eq('1234')
    end

    # provider: name
    it "has provider 'sesamestreet" do
      auth_hash['provider'].should eq('sesamestreet')
    end

    # info
    # {
    #   'nickname' => raw_info['nickname'],
    #   'email' => raw_info['email'],
    #   'name' => raw_info['name']
    # }
    it "adds hash of user data to info" do
      raw_info['nickname'] = 'bob'
      raw_info['email'] = 'bob@example.com'
      raw_info['name'] = 'Bob Shaw'
      auth_hash['info']['nickname'].should eq("bob")
      auth_hash['info']['email'].should eq("bob@example.com")
      auth_hash['info']['name'].should eq("Bob Shaw")
    end

    # extra
    # { 'raw_info' => raw_info }
    it "adds raw_info as extra" do
      auth_hash['extra']['raw_info'].should eq(raw_info)
    end

    # credentials
    # 'token' => access_token.token
    # 'refresh_token' => access_token.refresh_token if access_token.expires? && access_token.refresh_token
    # 'expires_at' => access_token.expires_at if access_token.expires?
    # 'expires' => access_token.expires?
    context "credentials" do
      it "sets token string from access_token object" do
        auth_hash['credentials']['token'].should eq(access_token.token)
      end

      it "sets ignores expiry data if access_token doesn't expire" do
        nonexpiring_auth_hash = auth_hash
        nonexpiring_auth_hash['credentials']['expires'].should be_false
        nonexpiring_auth_hash['credentials']['expires_at'].should be_nil
        nonexpiring_auth_hash['credentials']['refresh_token'].should be_nil
      end

      context "with expiry" do
        before do
          @timestamp = Time.now
          access_token.stub!(:expires? => true, :expires_at => @timestamp)
        end

        it "sets expires_at date if access_token expires" do
          expiring_auth_hash = auth_hash
          expiring_auth_hash['credentials']['expires'].should be_true
          expiring_auth_hash['credentials']['expires_at'].should eq(@timestamp)
          expiring_auth_hash['credentials']['refresh_token'].should be_nil
        end

        it "sets refresh_token date if access_token expires and access_token has a refresh_token" do
          access_token.stub!(:refresh_token => "5678wxyz")
          auth_hash['credentials']['refresh_token'].should eq("5678wxyz")
        end
      end

    end

  end
end