require "tapestry/version"
require "tapestry/element"

require "watir"

module Tapestry
  def self.included(caller)
    caller.extend Tapestry::Element
    caller.__send__ :include, Tapestry::Locator
  end

  def initialize(browser)
    @browser = browser
  end
end
