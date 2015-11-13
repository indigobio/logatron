module Logatron
  class BasicLogger
    include Logatron::Formatting

    MAP =  {
        Logatron::DEBUG => 0,
        Logatron::INFO => 1,
        Logatron::WARN => 2,
        Logatron::ERROR => 3,
        Logatron::CRITICAL => 4,
        Logatron::FATAL => 5

    }


    def level=(a_level)
      Logatron.configuration.logger.level = MAP[a_level]
    end

    def info(msg)
      write(format_log(msg: msg, severity: INFO), MAP[INFO])
    end

    def warn(msg)
      write(format_log(msg: msg, severity: WARN), MAP[WARN])
    end

    def debug(msg)
      write(format_log(msg: msg, severity: DEBUG), MAP[DEBUG])
    end

    def error(msg)
      write(format_log(msg: msg, severity: ERROR), MAP[ERROR])
    end

    def critical(msg)
      write(format_log(msg: msg, severity: CRITICAL), MAP[CRITICAL])
    end

    def fatal(msg)
      write(format_log(msg: msg, severity: FATAL), MAP[FATAL])
    end

    def log(id: '-', site: '-', msg: '-', severity: INFO, request: '-', status: '-', source: '-', &block)
      ml = Logatron::BasicScopedLogger.new(self)
      start = Time.now
      begin
        res = block.call(ml)
        write(format_log(severity: severity, msg: msg, status: status, duration: milliseconds_elapsed(Time.now, start), inputs: source, request: request),MAP[severity])
        res
      rescue Exception => e
        write(format_log(severity: severity, msg: msg, status: status, duration: milliseconds_elapsed(Time.now, start), inputs: source, request: request),MAP[severity])
        ml.flush
        raise e
      end
    end

    def write(string,severity)
      Logatron.configuration.logger.log(severity, string)
    end

  end

end

