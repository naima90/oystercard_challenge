require 'oystercard'

describe Oystercard do
  let (:entry_station) { double :entry_station }
  let (:exit_station) { double :exit_station }
  it { is_expected.to be_an Oystercard }

  subject(:card) { Oystercard.new }

  def top_up_touch_in
    subject.top_up(3)
    subject.touch_in(entry_station)
  end

  describe '#initialize' do
    it 'returns an empty list of journeys' do
      expect(card.journeys).to be_empty
    end
  end
  
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
    it { is_expected.to respond_to(:touch_in).with(1).argument }
    
    context 'without minimum balance' do
      it 'will not touch in' do
        expect { card.touch_in(entry_station) }.to raise_error "Minimum balance of #{Oystercard::MINIMUM_BALANCE} needed"
      end
    end

    context 'with minimum balance' do
      it 'can touch in' do
        top_up_touch_in
        expect(card).to be_in_journey
      end
    end

    it 'remembers entry stations' do
      top_up_touch_in
      expect(subject.entry_station).to eq entry_station
    end
  end

  describe '#touch_out' do
    it { is_expected.to respond_to(:touch_out).with(1).argument }
    
    context 'when ending a journey' do  
      before do
        card.top_up(Oystercard::MAXIMUM_BALANCE)
        card.touch_in(entry_station)
      end
      
      it 'can touch out' do
        card.touch_out(exit_station)
        expect(card).to_not be_in_journey
      end

      it 'forgets entry station on touch out' do
        subject.touch_out(exit_station)
        expect(subject).to_not be_in_journey
      end

      it 'stores the exit station' do
        card.touch_out(exit_station)
        expect(card.exit_station).to eq exit_station
      end

      it 'deducts the minimum fare' do
        expect { card.touch_out(exit_station) }.to change { card.balance }.by -Oystercard::MINIMUM_CHARGE
      end
      

    end
  end

  describe '#in_journey?' do
    it { is_expected.to respond_to :in_journey? }

    it 'has an initial value of false' do
      expect(card).to_not be_in_journey
    end
  end

  describe '#journeys' do
    let(:journey){ {entry_station: entry_station, exit_station: exit_station} }
  
    it 'creats one journey' do
      card.top_up(10)
      card.touch_in(entry_station)
      card.touch_out(exit_station)
      expect(card.journeys).to include journey
    end
  end

end
