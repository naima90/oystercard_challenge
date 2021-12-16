

class Oystercard
  MAXIMUM_BALANCE = 90
  MINIMUM_BALANCE = 1
  MINIMUM_CHARGE = 1

  attr_reader :balance, :in_journey, :entry_station

  def initialize
    @balance = 0
    @in_journey = false
  end

  def top_up(amount)
    @amount = amount
    raise "Maximum balance of #{MAXIMUM_BALANCE} exceeded" if limit_exceeded?
    @balance += @amount
  end

  def touch_in(station)
    raise "Minimum balance of #{MINIMUM_BALANCE} needed" if insufficient_funds?
    @in_journey = true
    @entry_station = station
  end

  def touch_out
    deduct(MINIMUM_CHARGE)
    @in_journey = false
    @entry_station = nil
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
