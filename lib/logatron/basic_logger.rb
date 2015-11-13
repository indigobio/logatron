module Logatron
  class BasicLogger
    include Logatron::Formatting

    def initialize(logger: Logger.new(STDOUT), level: Logatron::INFO)
      @level = level
      logger.formatter = Logatron::BasicFormatter.new
      @logger = logger
      @map =  {
          Logatron::DEBUG => 0,
          Logatron::INFO => 1,
          Logatron::WARN => 2,
          Logatron::ERROR => 3,
          Logatron::CRITICAL => 4,
          Logatron::FATAL => 5

      }
    end

    def level=(a_level)
      @level = a_level
      @logger.level = @map[@level]
    end

    def info(msg)
      write(format_log(msg: msg, severity: INFO), @map[INFO])
    end

    def warn(msg)
      write(format_log(msg: msg, severity: WARN), @map[WARN])
    end

    def debug(msg)
      write(format_log(msg: msg, severity: DEBUG), @map[DEBUG])
    end

    def error(msg)
      write(format_log(msg: msg, severity: ERROR), @map[ERROR])
    end

    def critical(msg)
      write(format_log(msg: msg, severity: CRITICAL), @map[CRITICAL])
    end

    def fatal(msg)
      write(format_log(msg: msg, severity: FATAL), @map[FATAL])
    end

    def log(id: '-', site: '-', msg: '-', severity: INFO, request: '-', status: '-', source: '-', &block)
      ml = Logatron::BasicScopedLogger.new(self)
      start = Time.now
      begin
        res = block.call(ml)
        write(format_log(severity: severity, msg: msg, status: status, duration: milliseconds_elapsed(Time.now, start), inputs: source, request: request),severity)
        res
      rescue Exception => e
        write(format_log(severity: severity, msg: msg, status: status, duration: milliseconds_elapsed(Time.now, start), inputs: source, request: request),severity)
        ml.flush
        raise e
      end
    end

    def write(string,severity)

      @logger.log(severity, string)
    end

  end

end

