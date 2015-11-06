require 'active_support/all'
require 'ascent/logger/version'
require 'ascent/logger/const'
require 'ascent/logger/contexts'
require 'ascent/logger/message_formatting'
require 'ascent/logger/basic_scoped_logger'
require 'ascent/logger/basic_formatter'
require 'ascent/logger/basic_logger'
require 'ascent/logger/configuration'

module Ascent
  module Logger
   class << self
     attr_internal :log
     def logger
       @log ||= Ascent::Logger::BasicLogger.new(logger:configuration.logger)
     end

     def log_exception(e, severity)
       logger.send(severity.downcase, "#{e.class} #{configuration.backtrace_cleaner.clean(e.backtrace).join(' -> ')}")
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

    def log(id:Ascent::Logging::Contexts.msg_id, site: Ascent::Logging::Contexts.site, msg:'-', severity: INFO, request: '-', status: '-', source: '-', &block)
       logger.log(id:id, site:site, msg:msg, severity:severity, request:request, status:status, source:source, &block)
    end

     def site
       Ascent::Logger::Contexts.site
     end

     def site=(site)
       Ascent::Logger::Contexts.site = site
     end

     def msg_id
       Ascent::Logger::Contexts.msg_id
     end

     def msg_id=(id)
       Ascent::Logger::Contexts.msg_id = id
     end
   end
  end
end
