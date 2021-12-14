

class Oystercard
  MAXIMUM_BLANCE = 90

  attr_reader :balance

  def initialize
    @balance = 0
  end

  def top_up(amount)
    @amount = amount
    
    raise "The card limit is #{MAXIMUM_BLANCE}" if limit_exceeded?
    
    @balance += @amount
  end

  def deduct(amount)
    @balance -= amount
  end

  private

  def limit_exceeded?
    @balance + @amount > MAXIMUM_BLANCE
  end
end
