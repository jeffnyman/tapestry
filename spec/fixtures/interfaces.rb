class ValidPage
  include Tapestry

  url_is 'http://localhost:9292'
  url_matches /:\d{4}/

  %w(text_field button buttons file_field textarea select_list checkbox p div link element).each do |element|
    send element, :"#{element}", id: element
    send element, :"#{element}_proc", proc { browser.send(element, id: element) }
    send element, :"#{element}_lambda", -> { browser.send(element, id: element) }

    send element, :"#{element}_block" do
      browser.send(element, id: element)
    end

    send element, :"#{element}_block_arg" do |id|
      browser.send(element, id: id)
    end
  end
end

class EmptyInterface
  include Tapestry
end

class TestFactory
  include Tapestry::Factory

  attr_accessor :browser
  attr_accessor :context
end
