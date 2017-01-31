require "tapestry/situation"

module Tapestry
  module Interface
    module Page
      module Attribute
        include Situation

        def url_is(url = nil)
          url_is_empty if url.nil? && url_attribute.nil?
          url_is_empty if url.nil? || url.empty?
          @url = url
        end

        def url_attribute
          @url
        end
      end
    end
  end
end
