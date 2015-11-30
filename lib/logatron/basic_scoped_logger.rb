require 'logatron/const'
require 'logatron/basic_logger'
require 'logatron/message_formatting'
require 'logatron/configuration'

module Logatron
  class BasicScopedLogger
    include Logatron::Formatting

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
      write(format_log(msg: msg, severity: INFO), INFO)
    end

    def warn(msg)
      write(format_log(msg: msg, severity: WARN), WARN)
    end

    def debug(msg)
      write(format_log(msg: msg, severity: DEBUG), DEBUG)
    end

    def error(msg)
      write(format_log(msg: msg, severity: ERROR), ERROR)
    end

    def critical(msg)
      write(format_log(msg: msg, severity: CRITICAL), CRITICAL)
    end

    def fatal(msg)
      write(format_log(msg: msg, severity: FATAL), FATAL)
    end

    def write(string, severity=INFO)
      @logs[severity].push string
    end

    def flush
      Logatron.configuration.loggable_levels.each do |key|
        @logs[key].each do |item|
          @logger.write(item,SEVERITY_MAP[key])
        end
      end
    end
  end

end
