require 'rspec'
require 'logatron/message_formatting'
require 'logatron/basic_logger'

module Logatron
  describe Formatting do
    describe '.format_log' do
      it 'invokes a proc passing a structured hash' do
        structured_hash = {}
        Logatron.configure {|conf| conf.logger = Logger.new(STDOUT); conf.transformer = proc {|x| structured_hash = x; x[:body]}}
        BasicLogger.new.debug('blah')
        expect(structured_hash.keys).to eql [:timestamp,:severity,:host,:id,:site,:status,:duration,:request,:source,:body]
      end
    end
    describe '.milliseconds_elapsed' do
      include Formatting
      it 'Subtracts 2 times and returning the result as a duration in ms' do
        expect(milliseconds_elapsed(Time.now, Time.now - (60 * 60 * 24) ).round).to be(86400000)
      end
    end
  end
end