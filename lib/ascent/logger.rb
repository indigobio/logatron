require 'ascent/logger/version'
require 'ascent/logger/const'
require 'ascent/logger/basic_formatter'

module Ascent
  module Logger
   class << self
     attr_internal :log
     def self.logger
       @log ||= BasicLogger.new(configuration.logger)
     end

     def self.log_error(msg)
       logger.error msg
     end

     def self.log_exception(e, severity)
       logger.send(severity.downcase, "#{e.class} #{configuration.backtrace_cleaner.clean(e.backtrace).join(' -> ')}")
     end

     def self.site
       Contexts.site
     end
     def self.site=(site)
       Contexts.site = site
     end
     def self.msg_id
       Contexts.msg_id
     end
     def self.msg_id=(id)
       Contexts.msg_id = id
     end
   end
  end
end
