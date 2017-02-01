module Watir
  class Element
    OBSERVER_FILE = "/dom_observer.js".freeze
    DOM_OBSERVER = File.read("#{File.dirname(__FILE__)}#{OBSERVER_FILE}").freeze

    # This method makes a call to `execute_async_script` which means that the
    # DOM observer script must explicitly signal that it is finished by
    # invoking a callback. In this case, the callback is nothing more than
    # a delay. The delay is being used to allow the DOM to be updated before
    # script actions continue.
    #
    # The method returns true if the DOM has been changed within the element
    # context, while false means that the DOM has not yet finished changing.
    # Note the wording: "has not finished changing." It's known that the DOM
    # is changing because the observer has recognized that. So the question
    # this method is helping to answer is "has it finished?"
    #
    # Consider the following element definition:
    #
    #    p :page_list, id: 'navlist'
    #
    # You could then do this:
    #
    #    page_list.dom_updated?
    #
    # That would return true if the DOM content for page_list has finished
    # updating. If the DOM was in the process of being updated, this would
    # return false. You could also do this:
    #
    #    page_list.wait_until(&:dom_updated?).click
    #
    # This will use Watir's wait until functionality to wait for the DOM to
    # be updated within the context of the element. Note that the "&:" is
    # that the object that `dom_updated?` is being called on (in this case
    # `page_list`) substitutes the ampersand. You can also structure it like
    # this:
    #
    #    page_list.wait_until do |element|
    #        element.dom_updated?
    #    end
    #
    # The default delay of waiting for the DOM to start updating is 1.1
    # second. However, you can pass a delay value when you call the method
    # to set your own value, which can be useful for particular sensitivities
    # in the application you are testing.
    def dom_updated?(delay: 1.1)
      driver.manage.timeouts.script_timeout = delay + 1
      driver.execute_async_script(DOM_OBSERVER, wd, delay)
    rescue Selenium::WebDriver::Error::StaleElementReferenceError
      # This situation can occur when the DOM changes between two calls to
      # some element or aspect of the page. In this case, we are expecting
      # the DOM to be different so what's being handled here are those hard
      # to anticipate race conditions when "weird things happen" and DOM
      # updating plus script execution get interleaved.
      retry
    rescue Selenium::WebDriver::Error::JavascriptError => e
      # This situation can occur if the script execution has started before
      # a new page is fully loaded. The specific error being checked for here
      # is one that occurs when a new page is loaded as that page is trying
      # to execute a JavaScript function.
      retry if e.message.include?('document unloaded while waiting for result')
      raise
    ensure
      # Note that this setting here means any user-defined timeout would
      # effectively be overwritten.
      driver.manage.timeouts.script_timeout = 1
    end

    alias dom_has_updated? dom_updated?
    alias dom_has_changed? dom_updated?
    alias when_dom_updated dom_updated?
    alias when_dom_changed dom_updated?
  end
end
