require 'logger'
require 'logatron/const'
require 'logatron/basic_formatter'
require 'logatron/error_formatter'
require 'logatron/backtrace_cleaner'
require 'active_support/backtrace_cleaner'
require 'active_support/json'

module Logatron
  class << self
    def configuration=
      @configuration = configuration
    end

    def configuration
      @configuration ||= Configuration.new
    end
  end

  def self.configure
    configuration
    yield(configuration)
  end

  class Configuration
    attr_accessor :logger, :host, :level, :transformer, :app_id, :error_formatter
    attr_reader :loggable_levels, :backtrace_cleaner

    def initialize
      @logger = Logger.new(STDOUT)
      @app_id = 'N/A'
      @transformer = proc { |x| x.to_json }
      @host = `hostname`.chomp
      @level = INFO
      level_threshold = SEVERITY_MAP[@level]
      levels = Logatron::SEVERITY_MAP.keys
      @loggable_levels = levels.select { |level| SEVERITY_MAP[level] >= level_threshold }
      @backtrace_cleaner = Logatron::BacktraceCleaner.new
      @error_formatter = Logatron::ErrorFormatter.new
    end

    def logger=(logger)
      level = @logger.level
      @logger = logger
      @logger.level = level
      @logger.formatter = Logatron::BasicFormatter.new
    end
  end
end
