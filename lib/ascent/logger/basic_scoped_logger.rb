module Ascent
  module Logger
    class BasicScopedLogger
      include Ascent::Logger::Formatting

      def initialize(logger)
        @logger = logger
        @logs = {
            DEBUG => [],
            INFO => [],
            WARN => [],
            ERROR => [],
            CRITICAL => [],
            FATAL => []
        }
      end

      def info(msg)
        write(format_log(msg:msg, severity:INFO),INFO)
      end

      def warn(msg)
        write(format_log(msg:msg, severity:WARN),WARN)
      end

      def debug(msg)
        write(format_log(msg:msg, severity:DEBUG),DEBUG)
      end

      def error(msg)
        write(format_log(msg:msg, severity:ERROR),ERROR)
      end

      def critical(msg)
        write(format_log(msg:msg, severity:CRITICAL),CRITICAL)
      end

      def fatal(msg)
        write(format_log(msg:msg, severity:FATAL),FATAL)
      end

      def write(string,severity=INFO)
        @logs[severity].push string
      end

      def flush
        configuration.loggable_levels.each do |key|
          @logs[key].each do |item|
            @logger.write(item)
          end
        end
      end
    end

  end
end