require 'logatron'
Logatron.configure do |config|
  config.host = 'my_host'
  config.app_id = 'my_app_id'
  config.logger = Logger.new($stdout)
  config.level = Logatron::INFO
  config.add_rails_request_field(:user_agent, &:user_agent)
  config.base_controller_class = 'ActionController::Base'
end
