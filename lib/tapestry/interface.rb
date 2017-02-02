require "tapestry/situation"

module Tapestry
  module Interface
    module Page
      include Situation

      # The `visit` method provides navigation to a specific page by passing
      # in the URL. If no URL is passed in, this method will attempt to use
      # the `url_is` attribute from the interface it is being called on.
      def visit(url = nil)
        no_url_provided if url.nil? && url_attribute.nil?
        @browser.goto(url) unless url.nil?
        @browser.goto(url_attribute) if url.nil?
        self
      end

      alias view        visit
      alias navigate_to visit
      alias goto        visit
      alias perform     visit

      # A call to `url_attribute` returns what the value of the `url_is`
      # attribute is for the given interface. It's important to note that
      # this is not grabbing the URL that is displayed in the browser;
      # rather it's the one declared in the interface, if any.
      def url_attribute
        self.class.url_attribute
      end

      # A call to `secure?` returns true if the page is secure and false
      # otherwise. This is a simple check that looks for whether or not the
      # current URL begins with 'https'.
      def secure?
        !url.match(/^https/).nil?
      end

      # A call to `url` returns the actual URL of the page that is displayed
      # in the browser.
      def url
        @browser.url
      end

      alias page_url    url
      alias current_url url

      # A call to `title` returns the actual title of the page that is
      # displayed in the browser.
      def title
        @browser.title
      end

      alias page_title title

      # A call to `markup` returns all markup on a page. Generally you don't
      # just want the entire markup but rather want to parse the output of
      # the `markup` call.
      def markup
        browser.html
      end

      alias html markup

      # A call to `text` returns all text on a page. Note that this is text
      # that is taken out of the markup context. It is unlikely you will just
      # want the entire text but rather want to parse the output of the
      # `text` call.
      def text
        browser.text
      end

      alias page_text text

      # This method sends a standard "browser refresh" message to the browser.
      def refresh
        browser.refresh
      end

      alias refresh_page refresh

      # This method provides a call to the browser window to resize that
      # window to the specified width and height values.
      def resize(width, height)
        browser.window.resize_to(width, height)
      end

      alias resize_to resize

      # This method provides a call to the browser window to move the
      # window to the specified x and y screen coordinates.
      def move_to(x, y)
        browser.window.move_to(x, y)
      end

      # This method provides a call to the synchronous `execute_script`
      # action on the browser, passing in JavaScript that you want to have
      # executed against the current page. For example:
      #
      #    result = page.run_script("alert('Tapestry ran a script.')")
      #
      # You can also run full JavaScript snippets.
      #
      #    script = <<-JS
      #      return arguments[0].innerHTML
      #    JS
      #
      #    page.run_script(script, page.account)
      #
      # Here you pass two arguments to `run_script`. One is the script itself
      # and the other are some arguments that you want to pass as part of
      # of the execution. In this case, an element definition (`account`) is
      # being passed in.
      def run_script(script, *args)
        browser.execute_script(script, *args)
      end

      alias execute_script run_script

      # A call to `screenshot` saves a screenshot of the current browser
      # page. Note that this will grab the entire browser page, even portions
      # of it that are off panel and need to be scrolled to. You can pass in
      # the path and filename of the image that you want the screenshot
      # saved to.
      def screenshot(file)
        browser.save.screenshot(file)
      end

      alias save_screenshot screenshot
    end
  end
end
