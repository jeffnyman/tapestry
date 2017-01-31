module Tapestry
  module Interface
    module Page
      module Attribute
        def url_is(url)
          @url = url
        end

        def url_attribute
          @url
        end
      end
    end
  end
end
