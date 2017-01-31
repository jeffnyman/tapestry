RSpec.describe Tapestry::Interface::Page::Attribute do
  include_context :interface

  context 'an interface definition' do
    it 'allows a url_is attribute' do
      expect(interface_definition).to respond_to :url_is
    end

    it 'allows a url_attribute attribute' do
      expect(interface_definition).to respond_to :url_attribute
    end

    it 'provides no default url' do
      expect(empty_interface.url_attribute).to be_nil
    end

    it 'does not allow an empty url_is attribute' do
      expect {
        class PageWithEmptyUrlIs
          include Tapestry
          url_is
        end
      }.to raise_error Tapestry::Errors::NoUrlForDefinition
    end
  end
end
