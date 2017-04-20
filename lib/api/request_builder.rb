module Api
  module RequestBuilder
    def self.get(url)
      uri = URI(Api.url + '/v' + Api.version.to_s + url)
      req = Net::HTTP::Get.new(uri.request_uri)
      req.basic_auth Api.config[:client_key], Api.config[:client_secret]
      res = Net::HTTP.start(uri.host, uri.port, :use_ssl => true) {|http|
        http.request(req)
      }

      parsed = JSON.parse(res.body)

      if !parsed["error"].nil? && !parsed["error"].empty?
        raise parsed["error"]
      end

      parsed
    end

    def self.put(url, params = {})
      uri = URI(Api.url + '/v' + Api.version.to_s + url)
      req = Net::HTTP::Put.new(uri.request_uri)
      req.basic_auth Api.config[:client_key], Api.config[:client_secret]
      req.set_form_data(params)
      res = Net::HTTP.start(uri.host, uri.port, :use_ssl => true) {|http|
        http.request(req)
      }

      parsed = JSON.parse(res.body)

      if !parsed["error"].nil? && !parsed["error"].empty?
        raise parsed["error"]
      end

      parsed
    end

    def self.delete(url, params = {})
      uri = URI(Api.url + '/v' + Api.version.to_s + url)
      req = Net::HTTP::Delete.new(uri.request_uri)
      req.basic_auth Api.config[:client_key], Api.config[:client_secret]
      req.set_form_data(params)
      res = Net::HTTP.start(uri.host, uri.port, :use_ssl => true) {|http|
        http.request(req)
      }

      parsed = JSON.parse(res.body)

      if !parsed["error"].nil? && !parsed["error"].empty?
        raise parsed["error"]
      end

      parsed
    end

    def self.post(url, params = {})
      url = URI.parse(Api.url + '/v' + Api.version + url)
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
      http.basic_auth Api.config[:client_key], Api.config[:client_secret]
      response = http.post(url.path, params.map { |k, v| "#{k.to_s}=#{v}" }.join("&"))
    end
  end
end
