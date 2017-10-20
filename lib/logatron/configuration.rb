require 'logger'
require 'logatron/const'
require 'logatron/basic_formatter'
require 'logatron/error_formatter'
require 'logatron/backtrace_cleaner'
require 'active_support/backtrace_cleaner'
require 'active_support/json'

module Logatron
  class << self
    def configuration=(config)
      @configuration = config
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
    attr_accessor :logger, :host, :level, :transformer, :app_id, :error_formatter, :base_controller_class
    attr_reader :loggable_levels, :backtrace_cleaner, :custom_rails_request_fields

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
      @custom_rails_request_fields = []
    end

    def logger=(logger)
      level = @logger.level
      @logger = logger
      @logger.level = level
      @logger.formatter = Logatron::BasicFormatter.new
    end

    # Add custom fields to the request log line that is produced for every
    # rails request served. This will affect all rails requests for the project.
    #
    # @example
    #   config.add_rails_request_field(:user_agent) { |req| req.user_agent }
    #
    # @param name [Symbol] the display name for the value in the request log line
    # @yield [ActionDispatch::Request] block for determining the value to display
    #   in the request log line. Takes an optional rails request object for the
    #   current action as a parameter and returns the string value to put in the
    #   request log line.
    def add_rails_request_field(name, &value_block)
      @custom_rails_request_fields.push(name: name, value_block: value_block)
    end
  end
end
