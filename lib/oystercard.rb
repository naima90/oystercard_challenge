

class Oystercard
  MAXIMUM_BALANCE = 90
  MINIMUM_BALANCE = 1

  attr_reader :balance, :in_journey

  def initialize
    @balance = 0
    @in_journey = false
  end

  def top_up(amount)
    @amount = amount
    raise "Maximum balance of #{MAXIMUM_BALANCE} exceeded" if limit_exceeded?
    @balance += @amount
  end

  def deduct(amount)
    @balance -= amount
  end

  def touch_in
    raise "Minimum balance of #{MINIMUM_BALANCE} needed" if insufficient_funds?
    @in_journey = true
  end

  def touch_out
    @in_journey = false
  end

  def in_journey?
    @in_journey
  end

  def insufficient_funds?
    @balance < 1
  end

  private

  def limit_exceeded?
    @balance + @amount > MAXIMUM_BALANCE
  end
end
