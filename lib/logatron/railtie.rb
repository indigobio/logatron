require 'logatron'
begin
  require 'lograge'
rescue LoadError
  msg = [
      'Include "lograge" in your bundle. It was left out of the gemspec of',
      'Logatron to keep dependencies down for projects that do not use Rails.'
  ].join(' ')
  raise LoadError, msg
end
require 'syslog/logger'

module Syslog
  class Logger
    alias log add
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
      elsif env['rack.session'].nil? || env['rack.session']['warden.user.user.key'].nil?
        Logatron.msg_id = SecureRandom.uuid + '-id-anonymous'
      else
        Logatron.msg_id = SecureRandom.uuid + '-id-' + env['rack.session']['warden.user.user.key'][0][0].to_s
      end
      @app.call(env)
    end
  end

  module SetupLograge
    class << self
      def setup(app_config)
        app_config.lograge.logger = Logatron.configuration.logger
        app_config.lograge.enabled = true
        app_config.lograge.formatter = Lograge::Formatters::Json.new
        app_config.lograge.custom_options = lambda do |event|
          request = event.payload[:rails_request]
          standard_opts(request).merge(custom_opts(request))
        end
        app_config.after_initialize do
          setup_app_controller
        end
      end

      private

      def standard_opts(request)
        {
            source:    request.remote_ip,
            severity:  Logatron::INFO,
            site:      Logatron.site,
            timestamp: Time.now.iso8601,
            host:      Logatron.configuration.host,
            pid:       Process.pid,
            app_id:    Logatron.configuration.app_id,
            id:        Logatron.msg_id
        }
      end

      def custom_opts(request)
        Logatron.configuration.custom_rails_request_fields.each_with_object({}) do |e, a|
          a[e[:name]] = e[:value_block].call(request)
        end
      end

      def setup_app_controller
        controller_class = Logatron.configuration.base_controller_class.try(:constantize) || ActionController::Base
        original_append_method = controller_class.instance_method(:append_info_to_payload)
        controller_class.send(:define_method, :append_info_to_payload) do |payload|
          original_append_method.bind(self).call(payload)
          payload[:rails_request] = request
        end
      end
    end
  end

  # NOTE: This Railtie is not tested in this project. Doing so would require
  #   having a small rails app in the test folder, or using the 'combustion'
  #   gem. It isn't worth it. Just verify it works in the apps that use it.
  #   We will know if it doesn't work because there will not be log messages
  #   for requests.
  class Railtie < Rails::Railtie
    initializer 'logatron.configure_rails_initialization' do |app|
      if defined?(Warden::Manager)
        app.middleware.insert_before(Warden::Manager, Logatron::Middleware)
      else
        app.middleware.use Logatron::Middleware
      end
    end

    SetupLograge.setup(config)
  end
end
