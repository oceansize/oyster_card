require "./lib/journey"

class Oystercard

  MAXIMUM_BALANCE = 90
  MINIMUM_BALANCE = 1

  attr_reader :balance, :journey, :journey_history

  def initialize(journey: Journey)
    @balance = 0
    @journey_history = []
    @journey = journey
  end

  def top_up(amount_received)
    self.balance += amount_received
    raise "Over limit of £#{MAXIMUM_BALANCE}" if above_maximum_balance?
  end

  def touch_in(entry_station)
    raise "Too low funds" if below_minimum_balance?
    journey_history << journey.new(entry_station)
  end

  def touch_out(exit_station)
    end_journey(exit_station)
    deduct(journey_fare)
  end

  private

  attr_writer :balance, :journey_history, :current_journey
  attr_reader :journey

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

  def end_journey(exit_station)
    current_journey.end(exit_station)
  end

  def current_journey
    journey_history.last
  end
end
