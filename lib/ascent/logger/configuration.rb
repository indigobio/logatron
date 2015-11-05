require 'syslog/logger'

module Ascent
  module Logger
    class << self
      attr_accessor :configuration
    end

    def self.configure
      self.configuration ||= Configuration.new
      yield(configuration)
    end

    class Configuration
      attr_accessor  :logger, :host, :level
      attr_reader :loggable_levels, :backtrace_cleaner

      def initialize
        @logger = Syslog::Logger.new('ascent')
        @host = `hostname`.chomp
        @level = INFO
        levels =   [DEBUG,
                    INFO,
                    WARN,
                    ERROR,
                    CRITICAL,
                    FATAL]
        @loggable_levels = levels.slice(levels.index(@level),levels.size-1)
        bc = BacktraceCleaner.new
        bc.add_filter   { |line| line.gsub(Rails.root.to_s, '') }
        bc.add_silencer { |line| line =~ /gems/ }
        @backtrace_cleaner = bc
      end
    end
  end
end