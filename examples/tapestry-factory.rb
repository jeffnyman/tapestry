#!/usr/bin/env ruby
$: << "./lib"

require "rspec"
include RSpec::Matchers

require "tapestry"
include Tapestry::Factory

puts Tapestry::VERSION

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

Tapestry.set_browser :chrome

on_view(Home)

on(Home) do
  @context.login_form.click
  @context.username.set "admin"
  @context.password(id: 'password').set "admin"
  @context.login.click
  expect(@context.message.text).to eq('You are now logged in as admin.')
end

on(Navigation) do
  @context.page_list.wait_until(&:dom_updated?).click
  @context.planets.click
  expect(@context.planet_logo.exists?).to be true
end

Tapestry.quit_browser
