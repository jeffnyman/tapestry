require "tapestry/situation"

module Tapestry
  module Ready
    include Situation

    # The ReadyAttributes contains methods that can be called directly on the
    # interface class definition. These are very much like the attributes
    # that are used for defining aspects of the pages, such as `url_is` or
    # `title_is`. These attributes are included separately so as to maintain
    # more modularity.
    module ReadyAttributes
      # This method will provide a list of the ready_validations that have
      # been defined. This list will contain the list in the order that the
      # validations were defined in.
      def ready_validations
        if superclass.respond_to?(:ready_validations)
          superclass.ready_validations + _ready_validations
        else
          _ready_validations
        end
      end

      # When this attribute method is specified on an interface, it will
      # append the validation provided by the block.
      def page_ready(&block)
        _ready_validations << block
      end

      alias page_ready_when page_ready

      private

      def _ready_validations
        @_ready_validations ||= []
      end
    end

    def self.included(caller)
      caller.extend(ReadyAttributes)
    end

    # If a ready validation fails, the message reported by that failure will
    # be captured in the `ready_error` accessor.
    attr_accessor :ready, :ready_error

    # The `when_ready` method is called on an instance of an interface. This
    # executes the provided validation block after the page has been loaded.
    # The Ready object instance is yielded into the block.
    #
    # Calls to the `ready?` method use a poor-man's cache approach. The idea
    # here being that when a page has confirmed that it is ready, meaning that
    # no ready validations have failed, that information is stored so that any
    # subsequent calls to `ready?` do not query the ready validations again.
    def when_ready(&_block)
      already_marked_ready = ready

      # no_ready_check_possible unless block_given?

      self.ready = ready?
      not_ready_validation(ready_error || 'NO REASON PROVIDED') unless ready
      yield self if block_given?
    ensure
      self.ready = already_marked_ready
    end

    alias check_if_ready when_ready

    # The `ready?` method is used to check if the page has been loaded
    # successfully, which means that none of the ready validations have
    # indicated failure.
    #
    # When `ready?` is called, the blocks that were stored in the above
    # `ready_validations` array are instance evaluated against the current
    # page instance.
    def ready?
      self.ready_error = nil
      return true if ready
      ready_validations_pass?
    end

    private

    # This method checks if the ready validations that have been specified
    # have passed. If any ready validation fails, no matter if others have
    # succeeded, this method immediately returns false.
    def ready_validations_pass?
      self.class.ready_validations.all? do |validation|
        passed, message = instance_eval(&validation)
        self.ready_error = message if message && !passed
        passed
      end
    end
  end
end
