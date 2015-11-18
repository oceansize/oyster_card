require "./lib/journey_log"

class Oystercard

  MAXIMUM_BALANCE = 90
  MINIMUM_BALANCE = 1

  attr_reader :balance, :journey, :journey_log

  def initialize(journey_log: JourneyLog.new)
    @balance = 0
    @journey_log = journey_log
  end

  def top_up(amount_received)
    raise "Over limit of £#{MAXIMUM_BALANCE}" if above_maximum_balance?(amount_received)
    self.balance += amount_received
  end

  def touch_in(journey)
    raise "Too low funds" if below_minimum_balance?
    journey_log.start_journey(journey)
  end

  def touch_out(exit_station)
    journey_log.end_journey(exit_station)
    deduct(current_journey.fare)
  end

  private

  attr_writer :balance, :journey_log, :current_journey
  attr_reader :journey

  def deduct(amount_deducted)
    self.balance -= amount_deducted
  end

  def below_minimum_balance?
    balance < MINIMUM_BALANCE
  end

  def above_maximum_balance?(amount_received)
    balance + amount_received > MAXIMUM_BALANCE
  end

  def current_journey
    journey_log.current_journey
  end
end
