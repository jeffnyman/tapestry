RSpec.shared_examples_for 'element method for' do |elements|
  elements.each do |element|
    context "#{element} on the watir platform" do
      it "will locate a specific #{element} with a single locator" do
        allow(watir_element).to receive(:to_subtype).and_return(watir_element)
        expect(watir_browser).to receive(element).with(id: element).and_return(watir_element)
        expect(page_interface.send "#{element}").to eq(watir_element)
      end

      it "will locate a specific #{element} with a proc" do
        expect(watir_browser).to receive(element).with(id: element).and_return(watir_element)
        expect(page_interface.send "#{element}_proc").to eq(watir_element)
      end

      it "will locate a specific #{element} with a lambda" do
        expect(watir_browser).to receive(element).with(id: element).and_return(watir_element)
        expect(page_interface.send "#{element}_lambda").to eq(watir_element)
      end

      it "will locate a specific #{element} with a block" do
        expect(watir_browser).to receive(element).with(id: element).and_return(watir_element)
        expect(page_interface.send "#{element}_block", element).to eq(watir_element)
      end

      it "will locate a specific #{element} with a block and argument" do
        expect(watir_browser).to receive(element).with(id: element).and_return(watir_element)
        expect(page_interface.send "#{element}_block_arg", element).to eq(watir_element)
      end

      it "will use a subtype for an element locator" do
        if element == 'element'
          allow(watir_element).to receive(:to_subtype).and_return(watir_element)
          expect(watir_browser).to receive(element).with(id: element).and_return(watir_element)
          expect(page_interface.send "#{element}").to eq(watir_element)
        end
      end
    end
  end
end

RSpec.describe Tapestry::Element do
  include_context :interface
  include_context :element

  provides_an 'element method for', %w{text_field button buttons file_field textarea select_list checkbox p div link element}

  it 'provides a way to get a list of accepted elements' do
    expect(Tapestry.elements?).to include(:textarea)
  end

  it 'provides a way to check if an element is recognized' do
    expect(Tapestry.recognizes?("div")).to be_truthy
  end
end
