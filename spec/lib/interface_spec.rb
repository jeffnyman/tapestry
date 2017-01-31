RSpec.describe Tapestry::Interface::Page do
  include_context :interface

  context 'an instance of a page interface definition' do
    it 'allows navigation to a page based on explicit url' do
      expect(watir_browser).to receive(:goto).exactly(4).times
      page_interface.navigate_to('http://localhost:9292')
      page_interface.goto('http://localhost:9292')
      page_interface.view('http://localhost:9292')
      page_interface.visit('http://localhost:9292')
    end
  end
end
