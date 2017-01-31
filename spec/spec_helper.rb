require "bundler/setup"

require "simplecov"

SimpleCov.start do
  add_filter "/spec/"
end

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

RSpec.configure do |config|
  RSpec.shared_context :interface do
    let(:watir_browser)  { mock_driver }
    let(:page_interface) { ValidPage.new(watir_browser) }
  end
end

Dir['spec/fixtures/**/*.rb'].each do |file|
  require file.sub(/spec\//, '')
end
