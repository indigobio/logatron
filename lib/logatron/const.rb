module Logatron
  MSG_ID = :msg_id
  SITE = :site

  DEBUG = 'DEBUG'.freeze
  INVALID_USE = 'INVALID_USE'.freeze
  INFO = 'INFO'.freeze
  WARN = 'WARN'.freeze
  ERROR = 'ERROR'.freeze
  CRITICAL = 'CRITICAL'.freeze
  FATAL = 'FATAL'.freeze

  # Maps Constants to the Logger Severity Integers:
  #   DEBUG = 0
  #   INFO = 1
  #   WARN = 2
  #   ERROR = 3
  #   FATAL = 4
  #   UNKNOWN = 5
  # Note that the Logatron Severities will be put into
  # the logs (severity => INVALID_USE), for filtering purposes
  SEVERITY_MAP = {
    Logatron::DEBUG => 0,
    Logatron::INFO => 1,
    Logatron::INVALID_USE => 1,
    Logatron::WARN => 2,
    Logatron::ERROR => 3,
    Logatron::CRITICAL => 4,
    Logatron::FATAL => 5
  }.freeze
end
