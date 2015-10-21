class JourneyLog

  def initialize(journey_klass: Journey)
    @journey_klass = journey_klass
    @journeys = []
  end

  def start_journey(entry_station)
    @journeys << journey_klass.new(entry_station)
  end

  def end_journey(exit_station)
    current_journey.end(exit_station)
  end

  def current_journey
    @journeys.last
  end

  # This is going to mess them up!
  def journeys
    @journeys.dup
  end

  private

  attr_reader :journey_klass
end
