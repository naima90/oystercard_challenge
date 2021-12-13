require 'oystercard'

describe Oystercard do
  it { is_expected.to be_a Oystercard }
  it { is_expected.to respond_to(:balance) }

  subject(:card) { Oystercard.new }

  describe '#balance' do
    it 'has an initial balance of zero' do
      expect(card.balance).to eq(0)
    end
  end

end
