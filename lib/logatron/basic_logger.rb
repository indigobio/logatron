require 'logatron/message_formatting'
require 'logatron/const'
require 'logatron/configuration'
require 'logatron/basic_scoped_logger'
module Logatron
  class BasicLogger
    include Logatron::Formatting

    def level=(a_level)
      Logatron.configuration.logger.level = SEVERITY_MAP[a_level]
    end

    def info(msg)
      write(format_log(msg: msg, severity: INFO), SEVERITY_MAP[INFO])
    end

    def warn(msg)
      write(format_log(msg: msg, severity: WARN), SEVERITY_MAP[WARN])
    end

    def debug(msg)
      write(format_log(msg: msg, severity: DEBUG), SEVERITY_MAP[DEBUG])
    end

    def invalid_use(msg)
      write(format_log(msg: msg, severity: INVALID_USE), SEVERITY_MAP[INVALID_USE])
    end

    def error(msg)
      write(format_log(msg: msg, severity: ERROR), SEVERITY_MAP[ERROR])
    end

    def critical(msg)
      write(format_log(msg: msg, severity: CRITICAL), SEVERITY_MAP[CRITICAL])
    end

    def fatal(msg)
      write(format_log(msg: msg, severity: FATAL), SEVERITY_MAP[FATAL])
    end

    def log(id: '-', site: '-', msg: '-', severity: INFO, request: '-', status: '-', source: '-', &block)
      ml = Logatron::BasicScopedLogger.new(self)
      start = Time.now
      begin
        res = block.call(ml)
        write(format_log(severity: severity, msg: msg, status: status, duration: milliseconds_elapsed(Time.now, start), inputs: source, request: request), SEVERITY_MAP[severity])
        res
      rescue Exception => e
        write(format_log(severity: severity, msg: msg, status: status, duration: milliseconds_elapsed(Time.now, start), inputs: source, request: request), SEVERITY_MAP[severity])
        ml.flush
        raise e
      end
    end

    def write(string, severity)
      Logatron.configuration.logger.log(severity, string)
    end
  end
end
