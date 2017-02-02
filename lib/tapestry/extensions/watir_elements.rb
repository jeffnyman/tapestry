module Watir
  class CheckBox
    alias check     set
    alias uncheck   clear
    alias checked?  set?
  end

  class Radio
    alias choose  set
    alias chosen? set?
  end

  class TextField
    alias enter set
  end
end
