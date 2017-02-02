#!/usr/bin/env ruby
$: << "./lib"

require "rspec"
include RSpec::Matchers

require "tapestry"

class Dynamic
  include Tapestry

  url_is "http://localhost:9292/practice/dynamic_events"

  button :long,  id: 'long'
  button :quick, id: 'quick'
  button :stale, id: 'stale'
  button :fade,  id: 'fade'

  div :dom_events,    id: 'container1'
  div :stale_event,   id: 'container2'
  div :effect_events, id: 'container3'
end

Tapestry.start_browser

page = Dynamic.new

page.visit

expect(page.dom_events.dom_updated?).to be_truthy
expect(page.dom_events.wait_until(&:dom_updated?).spans.count).to eq(0)

page.long.click

expect(page.dom_events.dom_updated?).to be_falsey
expect(page.dom_events.wait_until(&:dom_updated?).spans.count).to eq(5)

page.quick.click

expect(page.dom_events.wait_until(&:dom_updated?).spans.count).to eq(25)

Tapestry.quit_browser
