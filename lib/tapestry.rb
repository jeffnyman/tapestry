require "tapestry/version"
require "tapestry/element"
require "tapestry/factory"
require "tapestry/interface"
require "tapestry/attribute"

require "tapestry/extensions/dom_observer"

require "watir"

module Tapestry
  def self.included(caller)
    caller.extend Tapestry::Element
    caller.extend Tapestry::Interface::Page::Attribute
    caller.__send__ :include, Tapestry::Locator
    caller.__send__ :include, Tapestry::Interface::Page
  end

  def initialize(browser = nil, &block)
    @browser = Tapestry.browser unless Tapestry.browser.nil?
    @browser = browser if Tapestry.browser.nil?
    instance_eval(&block) if block
  end

  class << self
    attr_accessor :browser

    def set_browser(app = :chrome, *args)
      @browser = Watir::Browser.new(app, *args)
      Tapestry.browser = @browser
    end

    alias start_browser set_browser

    def quit_browser
      @browser.quit
    end
  end
end
