module Logatron
  WARN = 'WARN'
  INFO = 'INFO'
  ERROR = 'ERROR'
  CRITICAL = 'CRITICAL'
  FATAL = 'FATAL'
  DEBUG = 'DEBUG'
  INVALID_USE = 'INVALID_USE'
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
