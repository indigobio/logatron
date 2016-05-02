require 'rspec'
require 'logatron/basic_scoped_logger'

module Logatron
  describe BasicScopedLogger do
    it 'it supports a set of severities for logging' do
      Logatron::SEVERITY_MAP.keys.map(&:downcase).each do |severity|
        expect(BasicScopedLogger.method_defined? severity).to be(true)
      end
    end

    it 'buffers all logs' do
      io = StringIO.new
      logger = BasicLogger.new
      Logatron.configure { |config| config.transformer = proc { |x| x[:body] }; config.logger = Logger.new(io); }
      bsl = BasicScopedLogger.new(logger)
      bsl.error('buffered')
      expect(io.string).to_not eql "buffered\n"
      bsl.flush
      expect(io.string).to eql "buffered\n"
    end
  end
end
