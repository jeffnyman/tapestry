class Object
  # This method is necessary to dynamically chain method calls. The reason
  # this is necessary the data setter initially has no idea of the actual
  # object it's going to be dealing with, particularly because part of its
  # job is to find that object and map a data string to it. Not only this,
  # but that element will have been called on a specific instance of a
  # interface class. With the example provide in the comments below for the
  # `using` method, the following would be the case:
  #
  # method_chain: warp_factor.set
  # o (object):   <WarpTravel:0x007f8b23224218>
  # m (method):   warp_factor
  # data:         1
  #
  # Thus what you end up with is:
  #
  #    <WarpTravel:0x007f8b23224218>.warp_factor.set 1
  def chain(method_chain, data = nil)
    return self if method_chain.empty?
    method_chain.split('.').inject(self) do |o, m|
      if data.nil?
        o.send(m.intern)
      else
        o.send(m.intern, data)
      end
    end
  end
end

module Tapestry
  module DataSetter
    # The `using` method tells Tapestry to match up whatever data is passed
    # in via the action with element definitions. If those elements are found,
    # they will be populated with the specified data. Consider the following:
    #
    #    class WarpTravel
    #      include Tapestry
    #
    #      text_field :warp_factor, id: 'warpInput'
    #      text_field :velocity,    id: 'velocityInput'
    #      text_field :distance,    id: 'distInput'
    #    end
    #
    # Assuming an instance of this class called `page`, you could do the
    # following:
    #
    #    page.using_data(warp_factor: 1, velocity: 1, distance: 4.3)
    #
    # This is based on conventions. The idea is that element definitions are
    # written in the form of "snake case" -- meaning, underscores between
    # each separate word. In the above example, "warp_factor: 1" would be
    # matched to the `warp_factor` element and the value used for that
    # element would be "1". The default operation for a text field is to
    # enter the value in. It is also possible to use strings:
    #
    #    page.using_data("warp factor": 1, velocity: 1, distance: 4.3)
    #
    # Here "warp factor" would be converted to "warp_factor".
    def using(data)
      data.each do |key, value|
        use_data_with(key, value) if object_enabled_for(key)
      end
    end

    alias using_data   using
    alias use_data     using
    alias using_values using
    alias use_values   using

    private

    # This is the method that is delegated to in order to make sure that
    # elements are interacted with appropriately. This will in turn delegate
    # to `set_and_select` and `check_and_uncheck`, which determines what
    # actions are viable based on the type of element that is being dealt
    # with. These aspects are what tie this particular implementation to
    # Watir.
    def use_data_with(key, value)
      element = send(key.to_s.tr(' ', '_'))
      set_and_select(key, element, value)
      check_and_uncheck(key, element, value)
    end

    def set_and_select(key, element, value)
      key = key.to_s.tr(' ', '_')
      chain("#{key}.set", value)    if element.class == Watir::TextField
      chain("#{key}.set")           if element.class == Watir::Radio
      chain("#{key}.select", value) if element.class == Watir::Select
    end

    def check_and_uncheck(key, element, value)
      key = key.to_s.tr(' ', '_')
      return chain("#{key}.check") if element.class == Watir::CheckBox && value
      chain("#{key}.uncheck")      if element.class == Watir::CheckBox
    end

    # This is a sanity check method to make sure that whatever element is
    # being used as part of the data setting, it exists in the DOM, is
    # visible (meaning, display is not 'none'), and is capable of accepting
    # input, thus being enabled.
    def object_enabled_for(key)
      web_element = send(key.to_s.tr(' ', '_'))
      web_element.enabled? && web_element.visible?
    end
  end
end
