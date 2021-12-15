require 'oystercard'

describe Oystercard do
  it { is_expected.to be_an Oystercard }

  subject(:card) { Oystercard.new }

  describe '#balance' do
    it { is_expected.to respond_to(:balance) }

    it 'has an initial balance of zero' do
      expect(card.balance).to eq(0)
    end
  end

  describe '#top_up' do
    it { is_expected.to respond_to(:top_up).with(1).argument }
    
    it 'can top up balance' do
      expect { card.top_up 10 }.to change{ card.balance }.by 10
    end

    it 'raises an error if the maximum balance is exceeded' do
      maximum_balance = Oystercard::MAXIMUM_BALANCE
      card.top_up(maximum_balance)
      expect { card.top_up(1) }.to raise_error "Maximum balance of #{maximum_balance} exceeded"
    end
  end

  describe '#touch_in' do
    it { is_expected.to respond_to :touch_in }
    
    context 'without minimum balance' do
      it 'will not touch in' do
        expect { card.touch_in }.to raise_error "Minimum balance of #{Oystercard::MINIMUM_BALANCE} needed"
      end
    end

    context 'with minimum balance' do
      it 'can touch in' do
        card.top_up(Oystercard::MAXIMUM_BALANCE)
        card.touch_in
        expect(card).to be_in_journey
      end
    end
  end

  describe '#touch_out' do
    it { is_expected.to respond_to :touch_out }
    
    context 'when ending a journey' do  
      before do
        card.top_up(Oystercard::MAXIMUM_BALANCE)
        card.touch_in
      end
      
      it 'can touch out' do
        card.touch_out
        expect(card).to_not be_in_journey
      end

      it 'deducts the minimum fare' do
        expect { card.touch_out }.to change { card.balance }.by -Oystercard::MINIMUM_CHARGE
      end
    end
  end

  describe '#in_journey?' do
    it { is_expected.to respond_to :in_journey? }

    it 'has an initial value of false' do
      expect(card).to_not be_in_journey
    end
  end

end
