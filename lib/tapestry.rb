require "tapestry/version"
require "tapestry/element"
require "tapestry/interface"

require "watir"

module Tapestry
  def self.included(caller)
    caller.extend Tapestry::Element
    caller.__send__ :include, Tapestry::Locator
    caller.__send__ :include, Tapestry::Interface::Page
  end

  def initialize(browser)
    @browser = browser
  end
end
