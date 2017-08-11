require 'rspec'
require 'logatron/logatron'

module Logatron
  describe ErrorFormatter do
    let(:f) { Logatron.configuration.error_formatter }
    describe '#format_short_message' do
      it 'returns a string containing the exception type and message' do
        error = ArgumentError.new('bad arg')
        expected_text = 'ArgumentError: bad arg'
        expect(f.format_short_message(error)).to eql expected_text
      end
    end

    describe '#format_additional_info' do
      let(:error) { ArgumentError.new('oops') }
      it 'returns a string containing the exception metadata, if present and if additional info is not provided' do
        allow(error).to receive(:meta).and_return('the info')
        expected_text = '; MORE_INFO( the info )'
        expect(f.format_additional_info(error)).to eql expected_text
      end
      it 'returns an empty string if neither exception metadata nor additional info are present' do
        expect(f.format_additional_info(error)).to eql ''
      end
      it 'returns a string containing the info for hashes' do
        info = { a: 1, b: 'two' }
        allow(error).to receive(:meta).and_return(info)
        expected_text = '; MORE_INFO( {:a=>1, :b=>"two"} )'
        expect(f.format_additional_info(error)).to eql expected_text
      end
      it 'returns a string containing the info for string' do
        info = 'a b'
        allow(error).to receive(:meta).and_return(info)
        expected_text = '; MORE_INFO( a b )'
        expect(f.format_additional_info(error)).to eql expected_text
      end
    end

    describe '#format_full_message' do
      it 'returns the short message plus the additional info' do
        error = ArgumentError.new('bad arg')
        allow(error).to receive(:meta).and_return('the info')
        expected_text = f.format_short_message(error) + f.format_additional_info(error)
        expect(f.format_full_message(error)).to eql expected_text
      end
    end

    describe '#format_backtrace' do
      it 'given an error, returns a string with each frame on an indented line' do
        error = StandardError.new
        allow(error).to receive(:backtrace).and_return(%w(a b c))
        expected_text = <<EOD
      at a
      at b
      at c
EOD
        expect(f.format_backtrace(error)).to eql expected_text
      end
      it 'given a backtrace, returns a string with each frame on an indented line' do
        expected_text = <<EOD
      at a
      at b
      at c
EOD
        expect(f.format_backtrace(%w(a b c))).to eql expected_text
      end
    end

    describe '#format_error_report' do
      let(:error) { ArgumentError.new('oops') }
      before :each do
        allow(error).to receive(:backtrace).and_return(%w(a b c))
      end
      it 'returns an error report with backtrace' do
        expected_text = f.format_full_message(error) + "\n" +
            f.format_backtrace(error)
        expect(f.format_error_report(error)).to eql expected_text
      end
      it 'returns an error report with backtrace and additional info' do
        allow(error).to receive(:meta).and_return('42')
        expected_text = f.format_full_message(error) + "\n" +
            f.format_backtrace(error)
        expect(f.format_error_report(error)).to eql expected_text
      end
      context 'when there are inner errors' do
        let(:error) do
          run_and_rescue(proc { |e| e }) do
            run_and_rescue(proc { raise 'outermost' }) do
              run_and_rescue(proc { raise 'outer' }) do
                raise 'inner'
              end
            end
          end
        end
        it 'returns an intelligible error report' do
          allow(error.cause).to receive(:backtrace).and_return(%w(d e))
          allow(error.cause.cause).to receive(:backtrace).and_return(%w(f g))
          allow(error.cause.cause).to receive(:meta).and_return({q: 3})
          expected_text = <<EOD
RuntimeError: inner; MORE_INFO( {:q=>3} )
      at f
      at g
  which caused:
    RuntimeError: outer
      at d
      at e
  which caused:
    RuntimeError: outermost; MORE_INFO( {:x=>1, :y=>"2"} )
      at a
      at b
      at c
EOD
          expect(f.format_error_report(error, {x: 1, y: '2'})).to eql expected_text
        end
        it 'suppresses identical stack bases' do
          allow(error.cause.cause).to receive(:backtrace).and_return(%w(f e d c b a))
          allow(error.cause.cause).to receive(:meta).and_return({q: 3})
          allow(error.cause).to receive(:backtrace).and_return(%w(g f d c b a))
          allow(error).to receive(:backtrace).and_return(%w(h c b a))
          expected_text = <<EOD
RuntimeError: inner; MORE_INFO( {:q=>3} )
      at f
      at e
      at d
      ... 3 frames suppressed ...
  which caused:
    RuntimeError: outer
      at g
      at f
      at d
      at c
      ... 2 frames suppressed ...
  which caused:
    RuntimeError: outermost
      at h
      at c
      at b
      at a
EOD
          expect(f.format_error_report(error)).to eql expected_text
        end

        def run_and_rescue(rescuer, &func)
          begin
            func.call
          rescue => e
            rescuer.call(e)
          end
        end
      end
    end
  end
end
