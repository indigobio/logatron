require 'logatron/contexts'
require 'logatron/configuration'
require 'time'

module Logatron
  module Formatting
    def milliseconds_elapsed(finish, start)
      (finish - start) * 1000.0
    end

    def format_log(msg: '-', status: '-', duration: '-', request: '-', inputs: '-', severity: '-')
      Logatron.configuration.transformer.call(
        pid: Process.pid,
        app_id: Logatron.configuration.app_id,
        timestamp: Time.now.iso8601(3),
        severity: severity,
        host: Logatron.configuration.host,
        id: Contexts.msg_id,
        site: Contexts.site,
        status: status,
        duration: duration,
        request: request,
        source: inputs,
        body: msg)
    end
  end
end
