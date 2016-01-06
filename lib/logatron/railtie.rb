require 'lograge' # if this is an error for you, add 'lograge' to your bundle (left out of this gem's gemspec to keep dependencies down)

module Syslog
  class Logger
    alias_method :log, :add
  end
end

module Logatron
  class Middleware
    def initialize(app)
      @app = app
    end
    def call(env)
      request = ActionDispatch::Request.new(env)
      if request.headers['X-Ascent-Log-Id']
        Logatron.msg_id = request.headers['X-Ascent-Log-Id']
      elsif env['rack.session'].nil? or env['rack.session']['warden.user.user.key'].nil?
        Logatron.msg_id = SecureRandom.uuid + '-id-anonymous'
      else
        Logatron.msg_id = SecureRandom.uuid + '-id-' + env['rack.session']['warden.user.user.key'][0][0].to_s
      end
      @app.call(env)
    end
  end

  class Railtie < Rails::Railtie

    initializer 'logatron.configure_rails_initialization' do |app|

      if defined?(Warden::Manager)
        app.middleware.insert_before(Warden::Manager, Logatron::Middleware)
      else
        app.middleware.use Logatron::Middleware
      end

    end

      config.lograge.logger = Logatron.configuration.logger
      config.lograge.enabled = true
      config.lograge.formatter = Lograge::Formatters::Json.new
      config.lograge.custom_options = lambda do |event|
        {:source => event.payload[:ip], :severity=> Logatron::INFO, :site => Logatron.site, :timestamp => Time.now.iso8601, :host => Logatron.configuration.host, :id => Logatron.msg_id}
      end

  end

end
