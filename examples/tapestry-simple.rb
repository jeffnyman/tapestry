#!/usr/bin/env ruby
$: << "./lib"

require "rspec"
include RSpec::Matchers

require "tapestry"

puts Tapestry::VERSION

browser = Watir::Browser.new

class Home
  include Tapestry

  url_is "http://localhost:9292"

  p          :login_form, id: "open", visible: true
  text_field :username,   id: "username"
  text_field :password
  button     :login,      id: "login-button"

  #element :login_form, id: "open", visible: true
  #element :username,   id: "username"
  #element :password
  #element :login,      id: "login-button"
end

page = Home.new(browser)

# You can specify a URL to visit or you can rely on the provided
# url_is attribute on the page definition.
#page.visit("http://localhost:9292")
page.visit

page.login_form.click
page.username.set "admin"
page.password(id: 'password').set "admin"
page.login.click

browser.quit()
