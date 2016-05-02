require 'rspec'
require 'logatron/configuration'

module Logatron

  describe '.configuration' do
     it 'returns the configuration' do
       expect(Logatron.configuration).to be_a_kind_of Logatron::Configuration
     end
  end

  describe '.configure' do
    it 'yields the configuration to be changed' do
      Logatron.configure do |config|
         expect(config).to be_a_kind_of Logatron::Configuration
      end
    end
  end

  describe Configuration do
    describe '#initialize' do
      it 'sets reasonable defaults' do
        configuration = Configuration.new
        expect(configuration.logger).to be_a_kind_of(Logger)
        expect(configuration.host).to eql(`hostname`.chomp)
        expect(configuration.level).to eql(Logatron::INFO)
        expect(configuration.app_id).to eql('N/A')
        expect(configuration.loggable_levels).to eql [INFO,INVALID_USE,WARN,ERROR,CRITICAL,FATAL]
        expect(configuration.transformer.call({msg:'text'})).to eql '{"msg":"text"}'
      end
    end
    describe '.logger=' do
      it 'overwrites the current logger' do
        configuration = Configuration.new
        original_logger = configuration.logger
        configuration.logger = Logger.new(STDOUT)
        expect(configuration.logger).to be_a_kind_of(Logger)
        expect(configuration.logger.level).to eql original_logger.level
        expect(configuration.logger.formatter).to be_a_kind_of Logatron::BasicFormatter
      end
    end
  end
end
