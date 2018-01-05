require 'bundler/setup'
require 'webmock/rspec'
require 'rspec/junklet'
require 'support/simplecov'
require 'gifs'
require 'byebug'
require 'factory_bot'

Dir[File.join(Dir.getwd, 'spec/contexts/*.rb')].each { |f| require f }
Dir[File.join(Dir.getwd, 'spec/support/*.rb')].each { |f| require f }
Dir[File.join(Dir.getwd, 'spec/shared/*.rb')].each { |f| require f }

# override the config
ENV[Gifs::Config::DROPBOX_PATH] = fixture_dir
ENV[Gifs::Config::DROPBOX_TOKEN] = 'spec-helper-token'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
