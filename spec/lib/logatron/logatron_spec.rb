require 'rspec'
require 'logatron/logatron'

module Logatron
  describe 'log_exception' do
    let!(:logger) { Logatron::BasicLogger.new }
    let(:error) { StandardError.new('My message') }
    before :each do
      allow(Logatron).to receive(:logger) { logger }
      allow(error).to receive(:backtrace) { %w(one two three) }
    end
    context 'when additional information not provided' do
      it 'logs error with severity' do
        msg = 'StandardError My message -> one -> two -> three'
        expect(logger).to receive(:info).with(msg)
        Logatron.log_exception(error, Logatron::INFO)
      end
    end
    context 'when additional information is provided as hash' do
      it 'logs error with severity and hash values' do
        msg = 'StandardError My message; MORE_INFO( my=>hash, of=>values ) -> one -> two -> three'
        expect(logger).to receive(:info).with(msg)
        Logatron.log_exception(error, Logatron::INFO, my: 'hash', of: 'values')
      end
    end
    context 'when additional information is provided as a string' do
      it 'logs error with severity and hash values' do
        msg = 'StandardError My message; MORE_INFO( my string of values ) -> one -> two -> three'
        expect(logger).to receive(:info).with(msg)
        Logatron.log_exception(error, Logatron::INFO, 'my string of values')
      end
    end
  end
end
