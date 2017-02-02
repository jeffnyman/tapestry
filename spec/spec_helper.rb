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
    let(:watir_browser)        { mock_driver }
    let(:interface_definition) { ValidPage }
    let(:empty_interface)      { EmptyInterface.new(watir_browser) }
    let(:page_interface)       { ValidPage.new(watir_browser) }
  end

  RSpec.shared_context :element do
    let(:watir_element) { double('element') }
  end

  config.alias_it_should_behave_like_to :provides_an, 'when providing an'
end

Dir['spec/fixtures/**/*.rb'].each do |file|
  require file.sub(/spec\//, '')
end

RSpec.configure do |config|
  original_stderr = $stderr
  original_stdout = $stdout

  config.before(:all) do
    $stderr = File.new(File.join(File.dirname(__FILE__), 'reports/testable-output.txt'), 'w')
    $stdout = File.new(File.join(File.dirname(__FILE__), 'reports/testable-output.txt'), 'w')
  end

  config.after(:all) do
    $stderr = original_stderr
    $stdout = original_stdout
  end
end
