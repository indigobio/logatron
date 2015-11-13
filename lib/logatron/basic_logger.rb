module Logatron
  class BasicLogger
    include Logatron::Formatting

    def initialize(logger: Logger.new(STDOUT))
      logger.formatter = Logatron::BasicFormatter.new
      @logger = logger
    end

    def info(msg)
      write(format_log(msg: msg, severity: INFO))
    end

    def warn(msg)
      write(format_log(msg: msg, severity: WARN))
    end

    def debug(msg)
      write(format_log(msg: msg, severity: DEBUG))
    end

    def error(msg)
      write(format_log(msg: msg, severity: ERROR))
    end

    def critical(msg)
      write(format_log(msg: msg, severity: CRITICAL))
    end

    def fatal(msg)
      write(format_log(msg: msg, severity: FATAL))
    end

    def log(id: '-', site: '-', msg: '-', severity: INFO, request: '-', status: '-', source: '-', &block)
      ml = Logatron::BasicScopedLogger.new(self)
      start = Time.now
      begin
        block.call(ml)
        write(format_log(severity: severity, msg: msg, status: status, duration: milliseconds_elapsed(Time.now, start), inputs: source, request: request))
      rescue Exception => e
        write(format_log(severity: severity, msg: msg, status: status, duration: milliseconds_elapsed(Time.now, start), inputs: source, request: request))
        ml.flush
        raise e
      end
    end

    def write(string, severity=0)
      @logger.log(severity, string)
    end

  end

end

