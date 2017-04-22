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
      data       = Api::User.get_info

      expect(data["error"]).to eq "401 Unauthorized. Please supply the correct API key and API secret"
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
        test_id     = data.first["id"]
        test_name   = data.first["name"]
        single_test = Api::Tests.get_single_test(test_id)
        # using name instead of id because the response is missing id field
        expect(single_test["name"]).to eq test_name
      end
    end

    it "should fail when trying to access a test that is not mine" do
      test_id = 123423423423423
      data    = Api::Tests.get_single_test(test_id)
      expect(data["error"]).to eq "404 Not Found. Could not find test #{test_id}"
    end
  end

  context "update a test" do
    it "should update a test of mine" do
      data = Api::Tests.get_all["data"]
      if data.length > 0
        test_id = data.first["id"]
        new_name = rand(36**9).to_s(36)
        expect(Api::Tests.update_test(test_id, { :name => new_name })).to be true
        single_test = Api::Tests.get_single_test(test_id)
        expect(single_test["name"]).to eq new_name
      end
    end

    it "should not update a test that is not mine" do
      test_id = 123423423423423
      data    = Api::Tests.update_test(test_id, { :name => "testingbot" })
      expect(data["error"]).to eq "404 Not Found. Could not find test #{test_id}"
    end
  end

  context "delete a test" do
    it "should delete a test of mine" do
      data = Api::Tests.get_all["data"]
      if data.length > 0
        test_id = data.first["id"]
        expect(Api::Tests.delete_test(test_id)).to be true
        Api::Tests.get_single_test(test_id)
      end
    end

    it "should not delete a test that is not mine" do
      test_id = 123423423423423
      data    = Api::Tests.delete_test(test_id)
      expect(data["error"]).to eq "404 Not Found. Could not find test #{test_id}"
    end
  end

  context "retrieve my own TestLab tests" do
    it "should retrieve a list of my own TestLab tests" do
      expect(Api::TestlabTests.get_all.include?("data")).to be true
    end

    it "should provide info for a specific TestLab test" do
      data = Api::TestlabTests.get_all["data"]
      if data.length > 0
        test_id     = data.first["id"]
        test_name   = data.first["name"]
        single_test = Api::TestlabTests.get_single_test(test_id)
        # using name instead of id because the response is missing id field
        expect(single_test["name"]).to eq test_name
      end
    end

    it "should fail when trying to access a TestLab test that is not mine" do
      test_id = 123423423423423
      data    = Api::TestlabTests.get_single_test(test_id)
      expect(data["error"]).to eq "404 Not Found. Could not find lab test #{test_id}"
    end
  end

  context "update a TestLab test" do
    it "should update a TestLab test of mine" do
      data = Api::TestlabTests.get_all["data"]
      if data.length > 0
        test_id = data.first["id"]
        new_name = rand(36**9).to_s(36)
        expect(Api::TestlabTests.update_test(test_id, { :name => new_name })).to be true
        single_test = Api::TestlabTests.get_single_test(test_id)
        expect(single_test["name"]).to eq new_name
      end
    end

    it "should not update a TestLab test that is not mine" do
      data = Api::TestlabTests.update_test(123423423423423, { :name => "testingbot" })
      # it should be 403/404, shouldnt it?
      expect(data["error"]).to eq "500 Error. Something went wrong with the TestingBot API. Please try again later"
    end
  end

  context "delete a TestLab test" do
    it "should delete a TestLab test of mine" do
      data = Api::TestlabTests.get_all["data"]
      if data.length > 0
        test_id = data.first["id"]
        expect(Api::TestlabTests.delete_test(test_id)).to be true
        Api::TestlabTests.get_single_test(test_id)
      end
    end

    it "should not delete a test that is not mine" do
      test_id = 123423423423423
      data    = Api::TestlabTests.delete_test(test_id)
      expect(data["error"]).to eq "404 Not Found. Could not find lab test #{test_id}"
    end
  end
end
