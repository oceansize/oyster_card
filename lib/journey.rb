require "null_station"

class Journey
  MINIMUM_FARE = 1
  PENALTY_FARE = 6

  attr_reader :entry_station, :exit_station

  def initialize(entry_station)
    @entry_station = entry_station
  end

  def fare
    return PENALTY_FARE unless complete?
    MINIMUM_FARE
  end

  def end(station)
    @exit_station = station
  end

  def complete?
    entry_station && exit_station
  end

  def close
    @exit_station = NullStation.new
  end
end

