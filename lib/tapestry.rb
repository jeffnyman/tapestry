require "tapestry/version"
require "tapestry/element"
require "tapestry/factory"
require "tapestry/interface"
require "tapestry/attribute"
require "tapestry/ready"

require "tapestry/extensions/core_ruby"
require "tapestry/extensions/dom_observer"
require "tapestry/extensions/data_setter"
require "tapestry/extensions/watir_elements"

require "watir"

module Tapestry
  def self.included(caller)
    caller.extend Tapestry::Element
    caller.extend Tapestry::Interface::Page::Attribute
    caller.__send__ :include, Tapestry::Ready
    caller.__send__ :include, Tapestry::Locator
    caller.__send__ :include, Tapestry::Interface::Page
    caller.__send__ :include, Tapestry::DataSetter
  end

  def initialize(browser = nil, &block)
    @browser = Tapestry.browser unless Tapestry.browser.nil?
    @browser = browser if Tapestry.browser.nil?
    begin_with if respond_to?(:begin_with)
    instance_eval(&block) if block
  end

  # This accessor is needed so that internal API calls, like `markup` or
  # `text`, have access to the browser instance. This is an instance-level
  # access to the browser.
  attr_accessor :browser

  class << self
    # This accessor is needed so that Tapestry itself can provide a browser
    # reference to indicate connection to WebDriver. This is a class-level
    # access to the browser.
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
