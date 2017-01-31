module Tapestry
  module Interface
    module Page
      def visit(url)
        @browser.goto(url)
      end

      alias view        visit
      alias navigate_to visit
      alias goto        visit
    end
  end
end
