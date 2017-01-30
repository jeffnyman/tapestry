require "bundler/setup"
require "tapestry"

RSpec.configure do |config|
  # Limits the available syntax to the non-monkey patched syntax.
  config.disable_monkey_patching!

  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
