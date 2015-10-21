require "journey_log"

describe JourneyLog do
  subject(:log) { described_class.new(journey_klass: journey_klass) }

  let(:journey) { instance_spy("Journey", entry_station: entry_station, exit_station: exit_station, complete?: true, fare: 1) }
  let(:journey_klass) { class_spy("Journey", new: journey) }

  let(:entry_station) { double(:entry_station, zone: 1) }
  let(:exit_station) { double(:exit_station, zone: 2) }

  describe "Starting a journey" do

    before do
      allow(journey_klass).to receive(:new).and_return(journey)
    end

    it "logs the journey with the entry station" do
      log.start_journey(entry_station)
      expect(log.current_journey).to eq(journey)
    end
  end

  describe "Ending a journey" do
    it "adds the exit station to the current journey" do
      log.start_journey(entry_station)
      log.end_journey(exit_station)
      expect(journey).to have_received(:end).with(exit_station)
    end
  end

  describe "Keeping a history of journeys" do

    it "logs all journeys" do
      2.times { take_journey }
      expect(log.journeys).to eq([journey, journey])
    end
  end

  describe "Calculating outstanding fares" do
    let(:fare) { 5 }
    let(:incomplete_journey) { instance_spy("Journey", complete?: false, fare: fare) }

    before do
      allow(journey_klass).to receive(:new).and_return(journey, incomplete_journey)
      2.times { take_journey }
    end

    it "calculates the charges of all incomplete journeys" do
      expect(log.outstanding_charges).to eq(fare)
    end

    it "closes incomplete journeys" do
      log.outstanding_charges
      expect(incomplete_journey).to have_received(:close)
    end
  end

  def take_journey
    log.start_journey(entry_station)
    log.end_journey(exit_station)
  end
end
