require "null_station"

class Journey
  BASE_FARE = 1
  PENALTY_FARE = 6

  attr_reader :entry_station, :exit_station

  def initialize(entry_station)
    @entry_station = entry_station
  end

  def fare
    return PENALTY_FARE unless complete?
    BASE_FARE + zone_tariff
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

  private

  def zone_tariff
    zones_covered * BASE_FARE
  end

  def zones_covered
    (entry_station.zone - exit_station.zone).abs
  end
end

