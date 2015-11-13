module Logatron
  module Formatting
    def milliseconds_elapsed(finish, start)
      (finish - start) * 1000.0
    end

    def format_log(msg: '-', status: '-', duration: '-', request: '-', inputs: '-', severity: '-')
      {
          timestamp: Time.now.iso8601,
          severity: severity,
          host: Logatron.configuration.host,
          id: Contexts.msg_id,
          site: Contexts.site,
          status: status,
          duration: duration,
          request: request,
          source: inputs,
          body: msg
      }.to_json + "\n"
    end
  end
end


