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
  div        :message,    class: 'notice'

  #element :login_form, id: "open", visible: true
  #element :username,   id: "username"
  #element :password
  #element :login,      id: "login-button"
end

class Navigation
  include Tapestry

  p     :page_list,     id: 'navlist'
  link  :planets,       id: 'planets'

  image :planet_logo,   id: 'planet-logo'
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
expect(page.message.text).to eq('You are now logged in as admin.')

page = Navigation.new(browser)
page.page_list.wait_until(&:dom_updated?).click
page.planets.click
expect(page.planet_logo.exists?).to be true

browser.quit()
