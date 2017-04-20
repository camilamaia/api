require 'json'
require "net/http"
require 'rspec'
require "uri"

require "api/config"
require "api/request_builder"
require "api/tests"
require "api/user"
require "api/version"

module Api
  def self.version
    return 1
  end

  def self.url
    return "https://api.testingbot.com"
  end
end
