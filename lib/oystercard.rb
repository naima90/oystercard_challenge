

class Oystercard
  MAXIMUM_BALANCE = 90
  MINIMUM_BALANCE = 1
  MINIMUM_CHARGE = 1

  attr_reader :balance, :in_journey, :entry_station, :exit_station, :journeys

  def initialize
    @balance = 0
    @in_journey = false
    @journeys = [] 
    # @entry_station = []
    # @exit_station = []
  end

  def top_up(amount)
    @amount = amount
    raise "Maximum balance of #{MAXIMUM_BALANCE} exceeded" if limit_exceeded?
    @balance += @amount
  end

  def touch_in(station)
    raise "Minimum balance of #{MINIMUM_BALANCE} needed" if insufficient_funds?
    @entry_station = station
  end

  def touch_out(station)
    deduct(MINIMUM_CHARGE)
    @exit_station = station
    @journeys << {entry_station: @entry_station, exit_station: @exit_station}
    @entry_station = false
  end

  def in_journey?
    !!@entry_station
  end

  def insufficient_funds?
    @balance < 1
  end

  private

  def deduct(amount)
    @balance -= amount
  end

  def limit_exceeded?
    @balance + @amount > MAXIMUM_BALANCE
  end
end
