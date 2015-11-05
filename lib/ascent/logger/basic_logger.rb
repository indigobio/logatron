module Ascent
  module Logger
    class BasicLogger
      include Ascent::Logger::Formatting

        def initialize(logger:Logger.new(STDOUT))
          logger.formatter = BasicFormatter.new
          @logger = logger
        end

        def info(msg)
          write(format(msg:msg,severity:INFO))
        end

        def warn(msg)
          write(format(msg:msg,severity:WARN))
        end

        def debug(msg)
          write(format(msg:msg,severity:DEBUG))
        end

        def error(msg)
          write(format(msg:msg,severity:ERROR))
        end

        def critical(msg)
          write(format(msg:msg,severity:CRITICAL))
        end

        def fatal(msg)
          write(format(msg:msg,severity:FATAL))
        end

        def log(msg:'-', severity: INFO, request: '-', status: '-', source: '-', &block)
          ml = BasicScopedLogger.new(self)
          start = Time.now
          begin
            block.call(ml)
            write(format(severity:severity, msg:msg, status:status,duration:milliseconds_elapsed(Time.now,start), inputs:source, request:request))
          rescue Exception => e
            write(format(severity:severity, msg:msg, status:status,duration:milliseconds_elapsed(Time.now,start), inputs:source, request:request))
            ml.flush
            raise e
          end
        end

      def write(string,severity=0)
        @logger.log(severity,string)
      end

    end

  end
end