require 'spec_helper'

describe 'Logging of Rails HTTP requests', type: :request do
  before :each do
    load_rails
    require 'rspec/rails'
  end

  # I wasn't able to figure out a way to load Rails twice... So there is only one scenario.
  it 'respects custom field configuration' do
    expect do
      get '/my_route', headers: {'HTTP_USER_AGENT': 'some_agent/3.4.5'}
    end.to output(%r("user_agent":"some_agent/3.4.5")).to_stdout_from_any_process
  end

  def load_rails
    require 'combustion'
    Combustion.initialize! :action_controller do
      # happens only if logatron was loaded by previous spec
      if defined?(Logatron) && Logatron.methods.include?(:configuration)
        Logatron.configuration = nil
        load(File.expand_path('../../../../lib/logatron/logatron.rb', __FILE__))
      end
    end
  end
end
