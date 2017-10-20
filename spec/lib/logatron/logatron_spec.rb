require 'rspec'
require 'logatron'

module Logatron
  describe 'log_exception' do
    let!(:logger) { Logatron::BasicLogger.new }
    let(:error_formatter) { Logatron.configuration.error_formatter }
    let(:error) { StandardError.new }
    let(:additional_info) { { a: 1, b: 2 } }
    let(:the_report) { double }
    before :each do
      allow(Logatron).to receive(:logger) { logger }
    end
    it 'logs the formatted error at the given severity level' do
      level = 'ABCDEF' # doesn't matter. it's handled opaquely
      expect(error_formatter).to receive(:format_error_report).with(error, additional_info).and_return(the_report)
      expect(logger).to receive(level.downcase.to_sym).with(the_report)
      Logatron.log_exception(error, level, additional_info)
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
