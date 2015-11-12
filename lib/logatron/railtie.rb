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
    initializer 'my_railtie.configure_rails_initialization' do |app|

      if defined?(Warden::Manager)
        app.middleware.insert_before(Warden::Manager, Logatron::Middleware)
      else
        app.middleware.use Logatron::Middleware
      end
    end
  end

end