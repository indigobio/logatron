module Ascent
  module Logger
    module Formatting
      class << self

        def milliseconds_elapsed(finish, start)
          (finish - start) * 1000.0
        end

        def format(msg:'-', status:'-', duration:'-', request:'-', inputs:'-',severity: '-')
        {
            timestamp:Time.now.iso8601,
            severity:severity,
            host: configuration.host,
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
  end
end