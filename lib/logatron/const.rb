module Logatron
  WARN = 'WARN'
  INFO = 'INFO'
  ERROR = 'ERROR'
  CRITICAL = 'CRITICAL'
  FATAL = 'FATAL'
  DEBUG = 'DEBUG'
  MSG_ID = :msg_id
  SITE = :site
  SEVERITY_MAP =  {
      Logatron::DEBUG => 0,
      Logatron::INFO => 1,
      Logatron::WARN => 2,
      Logatron::ERROR => 3,
      Logatron::CRITICAL => 4,
      Logatron::FATAL => 5
  }
end
