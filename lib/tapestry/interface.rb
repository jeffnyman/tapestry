require "tapestry/situation"

module Tapestry
  module Interface
    module Page
      include Situation

      def visit(url = nil)
        no_url_provided if url.nil? && url_attribute.nil?
        @browser.goto(url) unless url.nil?
        @browser.goto(url_attribute) if url.nil?
      end

      alias view        visit
      alias navigate_to visit
      alias goto        visit

      def url_attribute
        self.class.url_attribute
      end
    end
  end
end
