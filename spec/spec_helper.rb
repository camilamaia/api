require File.expand_path(File.dirname(__FILE__) + '/../lib/api/config.rb')
require File.expand_path(File.dirname(__FILE__) + '/../lib/api.rb')

RSpec.configure do |config|
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true
end
