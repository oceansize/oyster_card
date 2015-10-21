require "journey"

describe Journey do
  subject(:journey) { described_class.new(:entry_station) }

  it "has an entry station" do
    expect(journey.entry_station).to eq(:entry_station)
  end

  describe "Ending a journey" do
    before do
      journey.end(:exit_station)
    end

    it "has an exit station once the journey has ended" do
      expect(journey.exit_station).to eq(:exit_station)
    end

    it "is marked as complete" do
      expect(journey).to be_complete
    end
  end

  describe "Fares" do
    context "when there is an entry station and exit station defined" do
      before do
        journey.end(:exit_station)
      end

      it "asks for the minimum fare" do
        expect(journey.fare).to eq(described_class::MINIMUM_FARE)
      end
    end

    context "when the journey is incomplete" do
      it "demands a penalty fare if there is no exit station" do
        expect(journey.fare).to eq(described_class::PENALTY_FARE)
      end
    end

    context "when there is no entry station" do
      subject(:journey) { described_class.new(nil) }

      it "demands a penalty fare" do
        expect(journey.fare).to eq(described_class::PENALTY_FARE)
      end
    end
  end

  describe "Closing an incomplete journey" do
    it "marks the journey as complete" do
      journey.close
      expect(journey).to be_complete
    end
  end
end
