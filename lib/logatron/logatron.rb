require 'active_support/all'
require 'logatron/version'
require 'logatron/const'
require 'logatron/contexts'
require 'logatron/error_formatter'
require 'logatron/message_formatting'
require 'logatron/backtrace_cleaner'
require 'logatron/basic_scoped_logger'
require 'logatron/basic_formatter'
require 'logatron/basic_logger'
require 'logatron/configuration'

module Logatron
  class << self
    attr_internal :log

    def logger
      @log ||= Logatron::BasicLogger.new
    end

    # @param additional_info [Object] Typically a flat hash, but can be anything that responds to '#to_s'
    def log_exception(e, severity, additional_info = {})
      error_report = configuration.error_formatter.format_error_report(e, additional_info)
      logger.send(severity.downcase, error_report)
    end

    def level=(level)
      logger.level = level
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

    # @deprecated Use operation_context for transportation-layer neutral data.
    def http_headers
      {
        'X-Ascent-Log-Id' => msg_id,
        'X-Ascent-Site' => site
      }
    end

    def operation_context
      {
        message_id: msg_id,
        site: site
      }
    end

    def operation_context=(info)
      return unless info.is_a? Hash
      self.msg_id = info[:message_id] || info['message_id'] || self.msg_id
      self.site = info[:site] || info['site'] || self.site
    end

    def log(id: msg_id, site: Logatron.site, msg: '-', severity: Logatron::INFO, request: '-', status: '-', source: '-', &block)
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
