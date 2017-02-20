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

  describe '::operation_context' do
    it 'returns a hash of the client request level parameters for serialization' do
      Logatron.msg_id = '12345'
      Logatron.site = 'cite'
      info = Logatron.operation_context
      expect(info).to be_a Hash
      expect(info[:message_id]).to eql '12345'
      expect(info[:site]).to eql 'cite'
    end
  end

  describe '::operation_context=' do
    it 'sets the message id' do
      Logatron.operation_context = {'message_id' => '12345'}
      expect(Logatron.msg_id).to eql '12345'

      Logatron.operation_context = {message_id: '12345'}
      expect(Logatron.msg_id).to eql '12345'
    end
    it 'sets the site' do
      Logatron.operation_context = {'site' => 'medtoxlabcorp'}
      expect(Logatron.site).to eql 'medtoxlabcorp'

      Logatron.operation_context = {site: 'medtoxlabcorp'}
      expect(Logatron.site).to eql 'medtoxlabcorp'
    end
    context 'when passed nil values' do
      it 'leaves the site and message id in their current states' do
        Logatron.msg_id = 'abcde'
        Logatron.site = 'corplabtoxmed'
        Logatron.operation_context = {site: nil, message_id: nil}
        expect(Logatron.msg_id).to eql 'abcde'
        expect(Logatron.site).to eql 'corplabtoxmed'
      end
    end
    context 'when not passed a hash' do
      it 'leaves the site and message id in their current states' do
        Logatron.msg_id = 'abcde'
        Logatron.site = 'corplabtoxmed'
        Logatron.operation_context = nil
        Logatron.operation_context = Object.new
        expect(Logatron.msg_id).to eql 'abcde'
        expect(Logatron.site).to eql 'corplabtoxmed'
      end
    end
  end
end
