# TestingBot Client Api
Client gem to easily interact with the TestingBot Api https://testingbot.com/support/api


## How to install?

You can install the api testingbot ruby-gem by running on your commandline.

``` bash
 $ git clone git@github.com:camilamaia/api.git
 $ cd api
 $ gem build api.gemspec
 $ gem install api-0.1.0.gem
 ```
 
## Set up

After you installed the gem you need to run a one part setup. Type api in your commandline and fill in the API key and API secret you obtained on testingbot.com

``` bash
 $ api
```

## Usage

### Configurations

``` ruby
 $ Api.config
 $ Api.config = { :client_key => "bogus", :client_secret => "0000" }
 $ Api.reset_config!
```

### User

``` ruby
 $ Api::User.get_info
 $ Api::User.update_info({ "first_name" => new_name })
```

### Tests

``` ruby
 $ Api::Tests.get_all
 $ Api::Tests.get_single_test(123423423423423)
 $ Api::Tests.delete_test(123423423423423)
```

## Test this gem

The tests for this gem are located in the spec folder, you can run them with this Rake task:

``` bash
  rake spec
```

## More information

Get more information on testingbot.com


