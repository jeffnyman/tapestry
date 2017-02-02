RSpec.describe Tapestry::Interface::Page::Attribute do
  include_context :interface

  context 'an interface definition' do
    it 'allows a url_is attribute' do
      expect(interface_definition).to respond_to :url_is
    end

    it 'allows a url_attribute attribute' do
      expect(interface_definition).to respond_to :url_attribute
    end

    it 'allows a url_match_attribute attribute' do
      expect(interface_definition).to respond_to :url_match_attribute
    end

    it 'allows a title_attribute attribute' do
      expect(interface_definition).to respond_to :title_attribute
    end

    it 'provides no default url' do
      expect(empty_interface.url_attribute).to be_nil
    end

    it 'provides no default url matcher' do
      expect(empty_interface.url_match_attribute).to be_nil
    end

    it 'provides no default title' do
      expect(empty_interface.title_attribute).to be_nil
    end

    it 'does not allow an empty url_is attribute' do
      expect {
        class PageWithEmptyUrlIs
          include Tapestry
          url_is
        end
      }.to raise_error Tapestry::Errors::NoUrlForDefinition
    end

    it 'does not allow an empty url_matches attribute' do
      expect {
        class PageWithEmptyUrlMatches
          include Tapestry
          url_matches
        end
      }.to raise_error Tapestry::Errors::NoUrlMatchForDefinition
    end

    it 'does not allow an empty title_is attribute' do
      expect {
        class PageWithEmptyTitleIs
          include Tapestry
          title_is
        end
      }.to raise_error Tapestry::Errors::NoTitleForDefinition
    end

    it 'does not verify a url if the url_matches attribute has not been set' do
      expect {
        empty_interface.has_correct_url?
      }.to raise_error Tapestry::Errors::NoUrlMatchPossible
    end

    it 'does not verify a title if the title_is attribute has not been set' do
      expect {
        empty_interface.has_correct_title?
      }.to raise_error Tapestry::Errors::NoTitleForDefinition
    end
  end
end
