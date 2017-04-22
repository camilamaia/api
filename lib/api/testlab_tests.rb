module Api
  module TestlabTests
    def self.get_all(offset = 0, count = 10)
      Api::RequestBuilder.get("/lab?offset=#{offset}&count=#{count}")
    end

    def self.get_single_test(test_id)
      Api::RequestBuilder.get("/lab/#{test_id}")
    end

    def self.update_test(test_id, params = {})
      new_params = {}
      params.keys.each do |key|
        new_params["test[#{key}]"] = params[key]
      end
      response = Api::RequestBuilder.put("/lab/#{test_id}", new_params)
      response['error'] ? response : response["success"]
    end

    def self.delete_test(test_id)
      response = Api::RequestBuilder.delete("/lab/#{test_id}")
      response['error'] ? response : response["success"]
    end
  end
end
