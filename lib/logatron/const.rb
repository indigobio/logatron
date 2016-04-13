module Logatron
  WARN = 'WARN'
  INFO = 'INFO'
  ERROR = 'ERROR'
  CRITICAL = 'CRITICAL'
  FATAL = 'FATAL'
  DEBUG = 'DEBUG'
  INVALID_USE = 'INVALID_USE'
  UNKNOWN = 'UNKNOWN'
  MSG_ID = :msg_id
  SITE = :site
  SEVERITY_MAP =  {
      Logatron::DEBUG => 0,
      Logatron::INVALID_USE => 1,
      Logatron::INFO => 2,
      Logatron::WARN => 3,
      Logatron::UNKNOWN => 4,
      Logatron::ERROR => 5,
      Logatron::CRITICAL => 6,
      Logatron::FATAL => 7
  }
end
