module Api
  class Config

    attr_reader :options

    def initialize(options = {})
      @options = default_options
      @options = @options.merge(load_config_file)
      @options = @options.merge(load_config_environment)
      @options = @options.merge(options)
    end

    def [](key)
      @options[key]
    end

    def add_options(options = {})
      @options = @options.merge(options)
    end

    def []=(key, value)
      @options[key] = value
    end

    def options
      @options
    end

    def require_tunnel(host = "127.0.0.1", port = 4445)
      @options[:require_tunnel] = true
      @options[:host] = host
      @options[:port] = port
    end

    def client_key
      @options[:client_key]
    end

    def client_secret
      @options[:client_secret]
    end

    def desired_capabilities
      # check if instance of Selenium::WebDriver::Remote::Capabilities
      unless @options[:desired_capabilities].instance_of?(Hash) || @options[:desired_capabilities].instance_of?(Array)
        return symbolize_keys @options[:desired_capabilities].as_json
      end
      @options[:desired_capabilities]
    end

    private

    def symbolize_keys(hash)
      hash.inject({}) {|new_hash, key_value|
        key, value = key_value
        value = symbolize_keys(value) if value.is_a?(Hash)
        new_hash[key.to_sym] = value
        new_hash
      }
    end

    def default_desired_capabilities
      { :browserName => "firefox", :version => 9, :platform => "WINDOWS" }
    end

    def default_options
      {
        :host => "hub.testingbot.com",
        :port => 4444,
        :jenkins_output => true,
        :desired_capabilities => default_desired_capabilities
      }
    end

    def load_config_file
      options = {}

      is_windows = false

      begin
        require 'rbconfig'
        is_windows = (RbConfig::CONFIG['host_os'] =~ /mswin|mingw|cygwin/)
      rescue
        is_windows = (RUBY_PLATFORM =~ /w.*32/) || (ENV["OS"] && ENV["OS"] == "Windows_NT")
      end

      if is_windows
        config_file = "#{ENV['HOMEDRIVE']}\\.testingbot_api"
      else
        config_file = File.expand_path("~/.testingbot_api")
      end

      if File.exists?(config_file)
        str = File.open(config_file) { |f| f.readline }.chomp
        options[:client_key], options[:client_secret] = str.split(':')
      end

      options
    end

    def load_config_environment
      options = {}
      options[:client_key] = ENV['TESTINGBOT_CLIENTKEY']
      options[:client_secret] = ENV['TESTINGBOT_CLIENTSECRET']

      options.delete_if { |key, value| value.nil?}

      options
    end
  end
end
