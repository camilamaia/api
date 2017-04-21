module Api
  module RequestBuilder
    def self.get(url)
      params = {:method => :get, :url => full_url(url)}
      res    = make_request(params)

      parsed = JSON.parse(res.body)

      if !parsed["error"].nil? && !parsed["error"].empty?
        raise parsed["error"]
      end

      parsed
    end

    def self.put(url, params = {})
      params = {
        :method => :put,
        :url => full_url(url),
        :payload => params,
        :content_type => :json
      }

      res = make_request(params)

      parsed = JSON.parse(res.body)

      if !parsed["error"].nil? && !parsed["error"].empty?
        raise parsed["error"]
      end

      parsed
    end

    def self.delete(url, params = {})
      params.merge!({:method => :delete, :url => full_url(url)})
      res = make_request(params)

      parsed = JSON.parse(res.body)

      if !parsed["error"].nil? && !parsed["error"].empty?
        raise parsed["error"]
      end

      parsed
    end

    def self.post(url, params = {})
      params = {
        :method => :post,
        :url => full_url(url),
        :payload => params,
        :content_type => :json
      }
      res = make_request(params)
    end

    def self.make_request req_params
      begin
        RestClient::Request.execute req_params.merge auth_details
      rescue RestClient::Unauthorized, RestClient::Forbidden => err
        puts 'Access denied'
        return err.response
      end
    end

    def self.auth_details
      {:user => Api.client_key, :password => Api.client_secret}
    end

    def self.full_url url
      "#{Api.url}/v#{Api.version.to_s}".concat(url)
    end
  end
end
