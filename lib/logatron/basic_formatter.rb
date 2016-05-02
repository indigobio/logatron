module Logatron
  class BasicFormatter
    def call(_severity, _time, _progname, msg)
      msg
    end
  end
end
