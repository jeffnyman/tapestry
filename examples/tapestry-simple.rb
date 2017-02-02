#!/usr/bin/env ruby
$: << "./lib"

require "rspec"
include RSpec::Matchers

require "tapestry"

puts Tapestry::VERSION
puts Tapestry.version
puts Tapestry.dependencies
puts Tapestry.elements?
puts Tapestry.recognizes?("div")

class Home
  include Tapestry

  url_is "http://localhost:9292/"
  url_matches /:\d{4}/
  title_is "Veilus"

  # Elements can be defined with HTML-style names as found in Watir.
  p          :login_form, id: "open", visible: true
  text_field :username,   id: "username"
  text_field :password
  button     :login,      id: "login-button"
  div        :message,    class: 'notice'

  # Elements can be defined with a generic name.
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

Tapestry.start_browser

page = Home.new

expect(Tapestry.browser).to be_an_instance_of(Watir::Browser)
expect(Tapestry.browser.driver).to be_an_instance_of(Selenium::WebDriver::Driver)

expect(page).to be_a_kind_of(Tapestry)
expect(page).to be_an_instance_of(Home)

# You can specify a URL to visit or you can rely on the provided
# url_is attribute on the page definition.
#page.visit("http://localhost:9292")
page.visit

expect(page.url).to eq(page.url_attribute)
expect(page.url).to match(page.url_match_attribute)
expect(page.title).to eq(page.title_attribute)

expect(page.secure?).to be_falsey
expect(page).not_to be_secure

expect(page.has_correct_url?).to be_truthy
expect(page).to have_correct_url

expect(page.displayed?).to be_truthy
expect(page).to be_displayed

expect(page.has_correct_title?).to be_truthy
expect(page).to have_correct_title

page.login_form.click
page.username.set "admin"
page.password(id: 'password').set "admin"
page.login.click
expect(page.message.text).to eq('You are now logged in as admin.')

page = Navigation.new
page.page_list.wait_until(&:dom_updated?).click
page.planets.click
expect(page.planet_logo.exists?).to be true

Tapestry.quit_browser
