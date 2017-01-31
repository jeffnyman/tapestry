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

    it 'allows navigation to a page based on the url_is attribute' do
      expect(watir_browser).to receive(:goto).exactly(4).times
      page_interface.navigate_to
      page_interface.goto
      page_interface.view
      page_interface.visit
    end

    it 'provides a url_attribute for a url_is value' do
      expect(page_interface.url_attribute).to eq('http://localhost:9292')
    end

    it 'provides an exception when no url is provided and a visit is attempted' do
      expect { empty_interface.visit }.to raise_error Tapestry::Errors::NoUrlForDefinition
    end
  end
end
