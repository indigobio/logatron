require 'active_support/all'
require 'logatron/version'
require 'logatron/const'
require 'logatron/contexts'
require 'logatron/message_formatting'
require 'logatron/basic_scoped_logger'
require 'logatron/basic_formatter'
require 'logatron/basic_logger'
require 'logatron/configuration'

module Logatron
  class << self
    attr_internal :log

    def logger
      @log ||= Logatron::BasicLogger.new(logger: configuration.logger)
    end

    def log_exception(e, severity)
      logger.send(severity.downcase, "#{e.class} #{e.message} -> #{configuration.backtrace_cleaner.clean(e.backtrace).join(' -> ')}")
    end

    def error(msg)
      logger.error(msg)
    end

    def warn(msg)
      logger.warn(msg)
    end

    def info(msg)
      logger.info(msg)
    end

    def fatal(msg)
      logger.fatal(msg)
    end

    def critical(msg)
      logger.critical(msg)
    end

    def debug(msg)
      logger.debug(msg)
    end

    def http_headers
      {
          'X-Ascent-Log-Id' => msg_id
      }
    end

    def log(id: msg_id, site: site, msg: '-', severity: Logatron::INFO, request: '-', status: '-', source: '-', &block)
      logger.log(id: id, site: site, msg: msg, severity: severity, request: request, status: status, source: source, &block)
    end

    def site
      Logatron::Contexts.site
    end

    def site=(site)
      Logatron::Contexts.site = site
    end

    def msg_id
      Logatron::Contexts.msg_id
    end

    def msg_id=(id)
      Logatron::Contexts.msg_id = id
    end
  end
end

require 'logatron/railtie' if defined?(Rails)