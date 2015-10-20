class Oystercard

  MAXIMUM_BALANCE = 90
  MINIMUM_BALANCE = 1

  attr_reader :balance, :entry_station, :journey_history

  def initialize
    @balance = 0
    @journey_history = []
  end

  def top_up(amount_received)
    self.balance += amount_received
    raise "Over limit of £#{MAXIMUM_BALANCE}" if above_maximum_balance?
  end

  def in_journey?
    !entry_station.nil?
  end

  def touch_in(station)
    raise "Too low funds" if below_minimum_balance?
    self.entry_station = station
  end

  def touch_out
    self.journey_history << entry_station
    self.entry_station = nil
    deduct(journey_fare)
  end

  private

  attr_writer :balance, :entry_station
  attr_accessor :in_journey

  def journey_fare
    1
  end

  def deduct(amount_deducted)
    self.balance -= amount_deducted
  end

  def below_minimum_balance?
    balance < MINIMUM_BALANCE
  end

  def above_maximum_balance?
    balance > MAXIMUM_BALANCE
  end

end
