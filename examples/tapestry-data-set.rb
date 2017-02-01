#!/usr/bin/env ruby
$: << "./lib"

require "rspec"
include RSpec::Matchers

require "tapestry"
include Tapestry::Factory

class WarpTravel
  include Tapestry

  url_is    "http://localhost:9292/warp"

  text_field :warp_factor, id: 'warpInput'
  text_field :velocity,    id: 'velocityInput'
  text_field :distance,    id: 'distInput'
end

Tapestry.start_browser

on_view(WarpTravel).using_data("warp factor": 1, velocity: 1, distance: 4.3)

Tapestry.quit_browser
