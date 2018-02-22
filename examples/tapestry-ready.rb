#!/usr/bin/env ruby
$: << "./lib"

require "rspec"
include RSpec::Matchers

require "tapestry"

class PageReady
  include Tapestry

  url_is "https://veilus.herokuapp.com"

  element :logo, id: 'site-'
  element :login_form, id: 'openski'

  page_ready { [logo.exists?, "Test Gorilla logo is not present"] }
end

Tapestry.start_browser

page = PageReady.new

page.visit

# Uncomment one of these at a time to see that the page_ready part
# is working. The element definitions above are purposely incorrect.

# page.when_ready { page.login_form.click }
# page.login_form.click

Tapestry.quit_browser
