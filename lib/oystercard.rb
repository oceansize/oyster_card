class Oystercard

  LIMIT = 90

  attr_reader :balance

  def initialize
    @balance = 0
    @in_journey = false
  end

  def top_up(amount_received)
    self.balance += amount_received
    raise "Over limit of £#{LIMIT}" if balance > LIMIT
  end

  def deduct(amount_deducted)
    self.balance -= amount_deducted
  end

  def in_journey?
    in_journey
  end

  def touch_in
    self.in_journey = true
  end

  def touch_out
    self.in_journey = false
  end

  private

  attr_writer :balance
  attr_accessor :in_journey

end
