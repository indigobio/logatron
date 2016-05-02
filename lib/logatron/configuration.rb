require 'logger'
require 'logatron/const'
require 'logatron/basic_formatter'
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
    attr_accessor :logger, :host, :level, :transformer, :app_id
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
      bc = ActiveSupport::BacktraceCleaner.new
      bc.add_filter { |line| line.gsub(Rails.root.to_s, '') } if defined? Rails
      bc.add_silencer { |line| line =~ /gems/ }
      @backtrace_cleaner = bc
    end

    def logger=(logger)
      level = @logger.level
      @logger = logger
      @logger.level = level
      @logger.formatter = Logatron::BasicFormatter.new
    end
  end
end
