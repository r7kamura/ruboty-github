require "simplecov"
SimpleCov.start

require "ruboty/github"
require "webmock/rspec"

RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
end
