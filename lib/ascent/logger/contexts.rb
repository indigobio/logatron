module Ascent
  module Logger
    class Contexts
      def self.site
        Thread.current[SITE]
      end
      def self.site=(site)
        Thread.current[SITE] = site
      end
      def self.msg_id
        Thread.current[MSG_ID]
      end
      def self.msg_id=(id)
        Thread.current[MSG_ID] = id
      end
    end
  end
end