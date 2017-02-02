module Tapestry
  module Errors
    NoUrlForDefinition = Class.new(StandardError)
    NoUrlMatchForDefinition = Class.new(StandardError)
    NoTitleForDefinition = Class.new(StandardError)
    NoUrlMatchPossible = Class.new(StandardError)
  end
end
