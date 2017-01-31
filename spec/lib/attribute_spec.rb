RSpec.describe Tapestry::Interface::Page::Attribute do
  include_context :interface

  context 'an interface definition' do
    it 'allows a url_is attribute' do
      expect(interface_definition).to respond_to :url_is
    end

    it 'allows a url_attribute attribute' do
      expect(interface_definition).to respond_to :url_attribute
    end
  end
end
