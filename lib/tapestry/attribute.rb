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

        def url_matches(pattern = nil)
          url_match_is_empty if pattern.nil?
          url_match_is_empty if pattern.is_a?(String) && pattern.empty?
          @url_match = pattern
        end

        def title_is(title = nil)
          title_is_empty if title.nil? || title.empty?
          @title = title
        end

        def url_attribute
          @url
        end

        def url_match_attribute
          @url_match
        end

        def title_attribute
          @title
        end
      end
    end
  end
end
