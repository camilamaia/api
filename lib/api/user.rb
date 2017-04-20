module Api
  module User
    def self.get_user_info
      Api::RequestBuilder.get("/user")
    end

    def self.update_user_info(params = {})
      new_params = {}
      params.keys.each do |key|
        new_params["user[#{key}]"] = params[key]
      end
      response = Api::RequestBuilder.put("/user", new_params)
      response["success"]
    end
  end
end
