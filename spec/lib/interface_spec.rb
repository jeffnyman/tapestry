RSpec.describe Tapestry::Interface::Page do
  include_context :interface
  include_context :element

  context 'an instance of a page interface definition' do
    it 'allows navigation to a page based on explicit url' do
      expect(watir_browser).to receive(:goto).exactly(5).times
      page_interface.perform('http://localhost:9292')
      page_interface.navigate_to('http://localhost:9292')
      page_interface.goto('http://localhost:9292')
      page_interface.view('http://localhost:9292')
      page_interface.visit('http://localhost:9292')
    end

    it 'allows navigation to a page based on the url_is attribute' do
      expect(watir_browser).to receive(:goto).exactly(5).times
      page_interface.perform
      page_interface.navigate_to
      page_interface.goto
      page_interface.view
      page_interface.visit
    end

    it 'provides a url_attribute for a url_is value' do
      expect(page_interface).to respond_to :url_attribute
      expect(page_interface.url_attribute).to eq('http://localhost:9292')
    end

    it 'provides a url_match_attribute for a url_matches value' do
      expect(page_interface).to respond_to :url_match_attribute
      expect(page_interface.url_match_attribute).to eq(/:\d{4}/)
    end

    it 'provides a title_attribute for a title_is value' do
      expect(page_interface).to respond_to :title_attribute
      expect(page_interface.title_attribute).to eq('Veilus')
    end

    it 'verifies a url if the url_matches assertion has been set' do
      expect(watir_browser).to receive(:url).twice.and_return('http://localhost:9292')
      expect { page_interface.has_correct_url? }.not_to raise_error
      expect(page_interface.has_correct_url?).to be_truthy
    end

    it 'does not verify a url if the url does not match the url_matches assertion' do
      expect(watir_browser).to receive(:url).and_return('http://127.0.0.1')
      expect(page_interface.has_correct_url?).to be_falsey
    end

    it 'verifies a title if the title_is assertion has been set' do
      expect(watir_browser).to receive(:title).twice.and_return 'Veilus'
      expect { page_interface.has_correct_title? }.not_to raise_error
      expect(page_interface.has_correct_title?).to be_truthy
    end

    it 'does not verify a title if the title does not match the title_is assertion' do
      expect(watir_browser).to receive(:title).and_return('Page Title')
      expect(page_interface.has_correct_title?).to be_falsey
    end

    it 'checks if a page is displayed' do
      expect(watir_browser).to receive(:url).and_return('http://localhost:9292')
      page_interface.displayed?
    end

    it 'provides an exception when no url is provided and a visit is attempted' do
      expect { empty_interface.visit }.to raise_error Tapestry::Errors::NoUrlForDefinition
    end

    it 'verifies a secure page' do
      expect(watir_browser).to receive(:url).and_return('https://localhost:9292')
      expect(page_interface.secure?).to be_truthy
    end

    it 'allows access to the url of the page' do
      expect(watir_browser).to receive(:url).exactly(3).times.and_return('http://localhost:9292')
      expect(page_interface).to respond_to :url
      expect(page_interface.current_url).to eq('http://localhost:9292')
      expect(page_interface.page_url).to eq('http://localhost:9292')
      expect(page_interface.url).to eq('http://localhost:9292')
    end

    it 'allows access to the title of a page' do
      expect(watir_browser).to receive(:title).exactly(3).times.and_return('Veilus')
      expect(page_interface).to respond_to :title
      expect(page_interface.page_title).to eq('Veilus')
      expect(page_interface.title).to eq('Veilus')
      expect(page_interface.title).to include('Veil')
    end

    it 'allows access to the markup of a page' do
      expect(watir_browser).to receive(:html).exactly(3).times.and_return('<h1>Page Section</h1>')
      expect(page_interface.markup).to eq('<h1>Page Section</h1>')
      expect(page_interface.html).to eq('<h1>Page Section</h1>')
      expect(page_interface.html).to include('<h1>Page')
    end

    it 'allows access to the text of a page' do
      expect(watir_browser).to receive(:text).exactly(3).times.and_return('some page text')
      expect(page_interface.page_text).to eq('some page text')
      expect(page_interface.text).to eq('some page text')
      expect(page_interface.text).to include('page text')
    end

    it 'refreshes the page' do
      expect(watir_browser).to receive(:refresh).twice.and_return(watir_browser)
      page_interface.refresh_page
      page_interface.refresh
    end

    it 'allows for calls to resize the browser window' do
      expect(watir_browser).to receive(:resize_to).and_return(watir_browser)
      expect(watir_browser).to receive(:window).and_return(watir_browser)
      page_interface.resize_to(800, 800)
    end

    it 'allows for calls to move the browser window' do
      expect(watir_browser).to receive(:move_to).and_return(watir_browser)
      expect(watir_browser).to receive(:window).and_return(watir_browser)
      page_interface.move_to(0, 0)
    end

    it 'runs a script against the browser' do
      expect(watir_browser).to receive(:execute_script).twice.and_return('input')
      expect(page_interface.run_script('return document.activeElement')).to eq('input')
      expect(page_interface.execute_script('return document.activeElement')).to eq('input')
    end

    it 'runs a script, with arguments, against the browser' do
      expect(watir_browser).to receive(:execute_script).with('return arguments[0].innerHTML', watir_element).and_return('testing')
      expect(page_interface.execute_script('return arguments[0].innerHTML', watir_element)).to eq('testing')
    end

    it 'can grab a screenshot of the current page' do
      expect(watir_browser).to receive(:save).twice.and_return(watir_browser)
      expect(watir_browser).to receive(:screenshot).twice
      page_interface.screenshot('testing.png')
      page_interface.save_screenshot('testing.png')
    end
  end
end
