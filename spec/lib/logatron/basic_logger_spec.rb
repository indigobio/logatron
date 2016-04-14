require 'rspec'
require 'logatron/basic_logger'

module Logatron
  describe BasicLogger do
    it 'supports logging of various severities' do
      bl = BasicLogger.new
      io = StringIO.new
      Logatron.configure {|config| config.transformer = proc {|x| x[:severity] + ' ' + x[:body]}; config.logger = Logger.new(io); }
      Logatron::SEVERITY_MAP.keys.map(&:downcase).each do |severity|
        bl.send(severity, 'msg')
        expect(io.string).to eql("#{severity.upcase} msg\n")
        io.reopen
      end
    end

    describe '.log' do
      let(:bl) {BasicLogger.new}
      it 'adds a duration to the logs around the code that was invoked' do
        io = StringIO.new
        duration = 0
        Logatron.configure {|config| config.transformer = proc {|x| duration = x[:duration]; x[:duration].to_s}; config.logger = Logger.new(io); }
        bl.log {}
       expect(duration).to be_a_kind_of Float
      end
      context 'there are no errors' do
        it 'ignores any logs sent to the scoped logger' do
          io = StringIO.new
          Logatron.configure {|config| config.transformer = proc {|x| x[:body]}; config.logger = Logger.new(io); }
          bl.log do |sl|
            sl.info('I do not exist')
          end
          expect(io.string).to eql "-\n"
        end
      end
      context 'there are errors'do
        it 'writes out logs from the scoped logger' do
          io = StringIO.new
          Logatron.configure {|config| config.transformer = proc {|x| x[:body]}; config.logger = Logger.new(io); }
          begin
            bl.log do |sl|
              sl.info('I do not exist')
              raise 'anything'
            end
          rescue
          end
          expect(io.string).to eql "-\nI do not exist\n"
        end
      end
    end
  end
end