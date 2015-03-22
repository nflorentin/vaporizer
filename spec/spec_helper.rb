require 'rspec'
require 'vcr'
require 'webmock/rspec'
require 'vaporizer'

VCR.configure do |config|
  config.debug_logger = $stderr
  config.hook_into :webmock
  config.cassette_library_dir = "spec/fixtures"
end
