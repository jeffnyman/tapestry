require "tapestry/version"
require "tapestry/element"
require "tapestry/interface"
require "tapestry/attribute"

require "watir"

module Tapestry
  def self.included(caller)
    caller.extend Tapestry::Element
    caller.extend Tapestry::Interface::Page::Attribute
    caller.__send__ :include, Tapestry::Locator
    caller.__send__ :include, Tapestry::Interface::Page
  end

  def initialize(browser)
    @browser = browser
  end
end
