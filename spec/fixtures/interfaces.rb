class ValidPage
  include Tapestry

  url_is 'http://localhost:9292'

  text_field :text_field, id: 'text_field'
end

class EmptyInterface
  include Tapestry
end

class TestFactory
  include Tapestry::Factory

  attr_accessor :browser
  attr_accessor :context
end
