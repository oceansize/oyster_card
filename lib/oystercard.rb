class Oystercard

  MAXIMUM_BALANCE = 90
  MINIMUM_BALANCE = 1

  attr_reader :balance, :journey, :journey_history

  def initialize(journey = Journey.new)
    @balance = 0
    @journey_history = []
    @journey = journey
  end

  def top_up(amount_received)
    self.balance += amount_received
    raise "Over limit of £#{MAXIMUM_BALANCE}" if above_maximum_balance?
  end

  def in_journey?
    !entry_station.nil?
  end

  def touch_in(entry_station)
    raise "Too low funds" if below_minimum_balance?
    self.entry_station = entry_station
  end

  def touch_out(exit_station)
    self.exit_station = exit_station
    save_journey_history
    self.entry_station = nil
    deduct(journey_fare)
  end

  def entry_station
  end

  def exit_station
    current_journey[:exit_station]
  end

  private

  attr_writer :balance, :journey_history, :current_journey

  attr_accessor :in_journey

  def save_journey_history
    journey_history << current_journey
    reset_current_journey
  end

  def reset_current_journey
    self.current_journey = {entry_station: nil, exit_station: nil}
  end

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

  def entry_station=(station)
    current_journey[:entry_station] = station
  end

  def exit_station=(station)
    current_journey[:exit_station] = station
  end

end
