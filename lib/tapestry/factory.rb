module Tapestry
  module Factory
    # Creates a definition context for actions and establishes the context
    # for execution. Given an interface definition for a page like this:
    #
    #    class TestPage
    #      include Tapestry
    #
    #      url_is "http://localhost:9292"
    #    end
    #
    # You can do the following:
    #
    #    on_view(TestPage)
    #
    # Note that the actual factory creation is handled by `on`. This method
    # exists as a way to differentiate when an interface needs to be
    # visited.
    def on_view(definition, &block)
      on(definition, true, &block)
    end

    alias on_visit on_view

    # Creates a definition context for actions. If an existing context
    # exists, that context will be re-used. You can use this simply to keep
    # the context for a script clear. For example, say you have the following
    # interface definitions for pages:
    #
    #    class Home
    #      include Tapestry
    #      url_is "http://localhost:9292"
    #    end
    #
    #    class Navigation
    #      include Tapestry
    #    end
    #
    # You could then do this:
    #
    #    on_view(Home)
    #    on(Navigation)
    #
    # The Home definition needs the url_is attribute in order for the on_view
    # factory to work. But Navigation does not because the `on` method is not
    # attempting to visit, simply to reference. Note that you can use `on`
    # to visit, just by doing this:
    #
    #    on(Home, true)
    def on(definition, visit = false, &block)
      unless @context.is_a?(definition)
        @context = definition.new(@browser) if @browser
        @context = definition.new unless @browser
        @context.visit if visit
      end

      verify_page(@context)

      yield @context if block
      @context
    end

    # Creates a definition context for actions. Unlike the `on` factory, the
    # `on_new` factory will always create a new context and will never re-use
    # an existing one. The reason for using this factory might be that you
    # are on the same page, but a given action has changed it so much that
    # you want to reference it as a new version of that page, meaning a new
    # context is established.
    #
    # It's doubtful that you will want to rely on this factory too much.
    def on_new(definition, &block)
      @context = nil
      on(definition, &block)
    end

    alias on_page  on
    alias while_on on

    private

    def verify_page(context)
      return if context.url_match_attribute.nil?
      return if context.has_correct_url?
      raise Tapestry::Errors::PageURLFromFactoryNotVerified
    end
  end
end
