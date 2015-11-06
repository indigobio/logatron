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
       @log ||= BasicLogger.new(configuration.logger)
     end

     def log_error(msg)
       logger.error msg
     end

     def log_exception(e, severity)
       logger.send(severity.downcase, "#{e.class} #{configuration.backtrace_cleaner.clean(e.backtrace).join(' -> ')}")
     end

     def site
       Contexts.site
     end

     def site=(site)
       Contexts.site = site
     end

     def msg_id
       Contexts.msg_id
     end

     def msg_id=(id)
       Contexts.msg_id = id
     end
   end
  end
end
