require 'watir'

def mock_driver
  browser = double('watir')
  allow(browser).to receive(:is_a?).with(Watir::Browser).and_return(true)
  browser
end
