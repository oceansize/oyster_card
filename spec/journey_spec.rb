require "journey"

describe Journey do
  subject(:journey) { described_class.new(entry_station) }

  let(:entry_station) { double("Station", zone: 1) }

  it "has an entry station" do
    expect(journey.entry_station).to eq(entry_station)
  end

  describe "Ending a journey" do
    before do
      journey.end(:exit_station)
    end

    it "has an exit station once the journey has ended" do
      expect(journey.exit_station).to eq(:exit_station)
    end

    it "is marked as paid" do
      expect(journey).to be_paid
    end
  end

  describe "Fares" do
    context "when there is an entry station and exit station defined" do

      context "when in the same zone" do

        it "asks for the minimum fare" do
          journey.end(exit_station(1))
          expect(journey.fare).to eq(described_class::BASE_FARE)
        end
      end

      context "when in different zones" do

        it "asks for the minimum fare" do
          journey.end(exit_station(3))
          expect(journey.fare).to eq(described_class::BASE_FARE * 3)
        end
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
    it "marks the journey as paid" do
      journey.close
      expect(journey).to be_paid
    end
  end

  def exit_station(zone = 1)
    double("Station", zone: zone)
  end
end
