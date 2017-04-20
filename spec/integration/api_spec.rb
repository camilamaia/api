require "uri"
require "net/http"
require 'rspec'
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "Testingbot Api" do

  context "the API should return valid user information" do
    it "should return info for the current user" do
      Api::User.get_info.should_not be_empty
      Api::User.get_info["first_name"].should_not be_empty
    end

    it "should raise an error when wrong credentials are provided" do
      Api.config = { :client_key => "bogus", :client_secret => "false" }
      lambda { Api::User.get_info }.should raise_error(RuntimeError, /^401 Unauthorized/)
      Api.reset_config!
    end
  end

  context "updating my user info via the API should work" do
    it "should allow me to update my own user info" do
      new_name = rand(36**9).to_s(36)
      Api::User.update_info({ "first_name" => new_name }).should == true
      Api::User.get_info["first_name"].should == new_name
    end
  end

  context "retrieve my own tests" do
    it "should retrieve a list of my own tests" do
      Api::Tests.get_all.include?("data").should == true
    end

    it "should provide info for a specific test" do
      data = Api::Tests.get_all["data"]
      if data.length > 0
        test_id = data.first["id"]

        single_test = @api.get_single_test(test_id)
        single_test["id"].should == test_id
      end
    end

    it "should fail when trying to access a test that is not mine" do
      lambda { Api::Tests.get_single_test(123423423423423) }.should raise_error(RuntimeError, /^404 Not Found./)
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
        single_test["name"].should == new_name
      end
    end

    it "should not update a test that is not mine" do
      lambda { Api::Tests.update_test(123423423423423, { :name => "testingbot" }) }.should raise_error(RuntimeError, /^404 Not Found./)
    end
  end

  context "delete a test" do
    it "should delete a test of mine" do
      data = Api::Tests.get_all["data"]
      if data.length > 0
        test_id = data.first["id"]
        @api.delete_test(test_id).should == true
        lambda { Api::Tests.get_single_test(test_id) }.should raise_error(RuntimeError, /^404 Not Found./)
      end
    end

    it "should not delete a test that is not mine" do
      lambda { Api::Tests.delete_test(123423423423423) }.should raise_error(RuntimeError, /^404 Not Found./)
    end
  end
end
