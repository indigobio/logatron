module Logatron
  WARN = 'WARN'.freeze
  INFO = 'INFO'.freeze
  ERROR = 'ERROR'.freeze
  CRITICAL = 'CRITICAL'.freeze
  FATAL = 'FATAL'.freeze
  DEBUG = 'DEBUG'.freeze
  INVALID_USE = 'INVALID_USE'.freeze
  MSG_ID = :msg_id
  SITE = :site
  SEVERITY_MAP =  {
      Logatron::DEBUG => 0,
      Logatron::INVALID_USE => 1,
      Logatron::INFO => 2,
      Logatron::WARN => 3,
      Logatron::ERROR => 4,
      Logatron::CRITICAL => 5,
      Logatron::FATAL => 6
  }
end
