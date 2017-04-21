require "uri"
require "net/http"
require 'rspec'
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "Testingbot Api" do

  context "the API should return valid user information" do
    it "should return info for the current user" do
      expect(Api::User.get_info).not_to be_empty
      expect(Api::User.get_info["first_name"]).not_to be_empty
    end

    it "should raise an error when wrong credentials are provided" do
      Api.config = { :client_key => "bogus", :client_secret => "false" }
      begin
        Api::User.get_info
      rescue RestClient::Unauthorized => e
        expect(e.http_code).to eq 401
        expect(e.response.code).to eq 401
      end
      Api.reset_config!
    end
  end

  context "updating my user info via the API should work" do
    it "should allow me to update my own user info" do
      new_name = rand(36**9).to_s(36)
      expect(Api::User.update_info({ "first_name" => new_name })).to be true
      expect(Api::User.get_info["first_name"]).to eq new_name
    end
  end

  context "retrieve my own tests" do
    it "should retrieve a list of my own tests" do
      expect(Api::Tests.get_all.include?("data")).to be true
    end

    it "should provide info for a specific test" do
      data = Api::Tests.get_all["data"]
      if data.length > 0
        test_id = data.first["id"]

        single_test = @api.get_single_test(test_id)
        expect(single_test["id"]).to eq test_id
      end
    end

    it "should fail when trying to access a test that is not mine" do
      begin
        Api::Tests.get_single_test(123423423423423)
      rescue RestClient::ResourceNotFound => e
        expect(e.http_code).to eq 404
        expect(e.response.code).to eq 404
      end
    end
  end

  context "update a test" do
    it "should update a test of mine" do
      data = Api::Tests.get_all["data"]
      if data.length > 0
        test_id = data.first["id"]
        new_name = rand(36**9).to_s(36)
        @api.update_test(test_id, { :name => new_name }).should == true
        single_test = Api::Tests.get_single_test(test_id)
        expect(single_test["name"]).to eq new_name
      end
    end

    it "should not update a test that is not mine" do
      begin
        Api::Tests.update_test(123423423423423, { :name => "testingbot" })
      rescue RestClient::ResourceNotFound => e
        expect(e.http_code).to eq 404
        expect(e.response.code).to eq 404
      end
    end
  end

  context "delete a test" do
    it "should delete a test of mine" do
      data = Api::Tests.get_all["data"]
      if data.length > 0
        test_id = data.first["id"]
        expect(@api.delete_test(test_id)).to be true
        begin
          Api::Tests.get_single_test(test_id)
        rescue RestClient::ResourceNotFound => e
          expect(e.http_code).to eq 404
          expect(e.response.code).to eq 404
        end
      end
    end

    it "should not delete a test that is not mine" do
      begin
        Api::Tests.delete_test(123423423423423)
      rescue RestClient::ResourceNotFound => e
        expect(e.http_code).to eq 404
        expect(e.response.code).to eq 404
      end
    end
  end
end
