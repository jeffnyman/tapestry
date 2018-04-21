require "tapestry/situation"

module Tapestry
  module Interface
    module Page
      include Situation

      # The `visit` method provides navigation to a specific page by passing
      # in the URL. If no URL is passed in, this method will attempt to use
      # the `url_is` attribute from the interface it is being called on.
      def visit(url = nil, &block)
        no_url_provided if url.nil? && url_attribute.nil?
        @browser.goto(url) unless url.nil?
        @browser.goto(url_attribute) if url.nil?
        when_ready(&block) if block_given?
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

      # A call to `url_match_attribute` returns what the value of the
      # `url_matches` attribute is for the given interface. It's important
      # to note that the URL matching mechanism is effectively a regular
      # expression check.
      def url_match_attribute
        value = self.class.url_match_attribute
        return if value.nil?
        value = Regexp.new(value) unless value.is_a?(Regexp)
        value
      end

      # A call to `title_attribute` returns what the value of the `title_is`
      # attribute is for the given definition. It's important to note that
      # this is not grabbing the title that is displayed in the browser;
      # rather it's the one declared in the interface, if any.
      def title_attribute
        self.class.title_attribute
      end

      # A call to `has_correct_url?`returns true or false if the actual URL
      # found in the browser matches the `url_matches` assertion. This is
      # important to note. It's not using the `url_is` attribute nor the URL
      # displayed in the browser. It's using the `url_matches` attribute.
      def has_correct_url?
        if url_attribute.nil? && url_match_attribute.nil?
          no_url_match_is_possible
        end
        !(url =~ url_match_attribute).nil?
      end

      alias displayed? has_correct_url?

      # A call to `has_correct_title?` returns true or false if the actual
      # title of the current page in the browser matches the `title_is`
      # attribute. Notice that this check is done as part of a match rather
      # than a direct check. This allows for regular expressions to be used.
      def has_correct_title?
        no_title_is_provided if title_attribute.nil?
        !title.match(title_attribute).nil?
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

      # This method provides a means to maximize the browser window. This
      # is done by getting the screen width and height via JavaScript calls.
      def maximize
        browser.window.resize_to(screen_width, screen_height)
      end

      # This method provides a call to the browser window to resize that
      # window to the specified width and height values.
      def resize(width, height)
        browser.window.resize_to(width, height)
      end

      alias resize_to resize

      # This method provides a call to the browser window to move the
      # window to the specified x and y screen coordinates.
      def move_to(x_coord, y_coord)
        browser.window.move_to(x_coord, y_coord)
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

      # A call to `screen_width` returns the width of the browser screen as
      # reported by the browser API, using a JavaScript call to the `screen`
      # object.
      def screen_width
        run_script("return screen.width;")
      end

      # A call to `screen_height` returns the height of the browser screen as
      # reported by the browser API, using a JavaScript call to the `screen`
      # object.
      def screen_height
        run_script("return screen.height;")
      end

      # A call to `get_cookie` allows you to specify a particular cookie, by
      # name, and return the information specified in the cookie.
      def get_cookie(name)
        browser.cookies.to_a.each do |cookie|
          return cookie[:value] if cookie[:name] == name
        end
        nil
      end

      # A call to `clear_cookies` removes all the cookies from the current
      # instance of the browser that is being controlled by WebDriver.
      def clear_cookies
        browser.cookies.clear
      end

      alias remove_cookies clear_cookies

      def watir_api
        Tapestry.browser.methods - Object.public_methods
      end

      def watir_selectors
        Watir::Container.instance_methods
      end

      def selenium_api
        Tapestry.browser.driver.methods - Object.public_methods
      end

      def api
        methods - Object.public_methods
      end

      def definition_api
        public_methods(false) - Object.public_methods
      end
    end
  end
end
