require 'rspec'
require 'logatron/basic_formatter'

module Logatron
  describe BasicFormatter do
    describe '#call' do
      it 'returns just the plain message as passed in' do
        expect(BasicFormatter.new.call(nil, nil, nil, 'my message')).to eql('my message')
      end
    end
  end
end
