RSpec.describe Tapestry::DataSetter do
  include_context :interface
  include_context :element

  it 'attempts to utilize data' do
    expect(watir_element).to receive(:visible?).and_return(true)
    expect(watir_element).to receive(:enabled?).and_return(true)
    expect(watir_browser).to receive(:text_field).with({:id => 'text_field'}).exactly(2).times.and_return(watir_element)
    page_interface.using(:text_field => 'works')
  end

  it 'allows methods to be chained' do
    expect('testing'.chain('reverse.capitalize')).to eq('Gnitset')
    expect('testing'.chain('start_with?', 't')).to be_truthy
  end
end
