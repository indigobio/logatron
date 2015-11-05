module Ascent
  module Logger
    class BasicFormatter
      def call(severity, time, progname, msg)
        msg
      end
    end
  end
end
