require "journey_log"

describe JourneyLog do
  subject(:log) { described_class.new }

  let(:journey) { instance_spy("Journey", entry_station: entry_station, exit_station: exit_station, paid?: true, fare: 1) }

  let(:entry_station) { double(:entry_station, zone: 1) }
  let(:exit_station) { double(:exit_station, zone: 2) }

  describe "Starting a journey" do

    it "logs the journey with the entry station" do
      log.start_journey(journey)
      expect(log.current_journey).to eq(journey)
    end
  end

  describe "Ending a journey" do
    it "adds the exit station to the current journey" do
      log.start_journey(journey)
      log.end_journey(exit_station)
      expect(journey).to have_received(:end).with(exit_station)
    end
  end

  describe "Keeping a history of journeys" do

    it "logs all journeys" do
      2.times { take_journey(journey) }
      expect(log.journeys).to eq([journey, journey])
    end
  end

  describe "Calculating outstanding fares" do
    let(:fare) { 5 }
    let(:incomplete_journey) { instance_spy("Journey", paid?: false, fare: fare) }

    before do
      take_journey(journey)
      take_journey(incomplete_journey)
    end

    it "calculates the charges of all incomplete journeys" do
      expect(log.outstanding_charges).to eq(fare)
    end

    it "closes incomplete journeys" do
      log.outstanding_charges
      expect(incomplete_journey).to have_received(:close)
    end
  end

  def take_journey(journey)
    log.start_journey(journey)
    log.end_journey(exit_station)
  end
end
