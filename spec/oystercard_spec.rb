require 'oystercard'

describe Oystercard do

  subject(:oystercard) { described_class.new }

  it "has a balance of £0" do
    expect(oystercard.balance).to eq(0)
  end

  it "by default is not in an active journey" do
    expect(oystercard).to_not be_in_journey
  end

  it "has an empty journey list by default" do
    expect(oystercard.journey_history).to eq([])
  end

  describe "Topping up" do

    it "can be topped up with an amount of money" do
      oystercard.top_up(10)
      expect(oystercard.balance).to eq(10)
    end

    it "prevents more than the limit on the oystercard being topped up" do
      large_amount = described_class::MAXIMUM_BALANCE + 10
      expect { oystercard.top_up(large_amount) }.to raise_error "Over limit of £90"
    end
  end

  describe "Touching in and out" do

    let(:entry_station) { :entry_station }
    let(:exit_station) { :exit_station }
    let(:journey) { { entry_station: entry_station, exit_station: exit_station } }

    context "with adequate funds for travel" do

      before do
        oystercard.top_up(1)
      end

      it "remembers the entry station after touching in" do
        oystercard.touch_in(entry_station)
        expect(oystercard.entry_station).to eq(:entry_station)
      end

      it "is in an active journey after touching in" do
        oystercard.touch_in(entry_station)
        expect(oystercard).to be_in_journey
      end

      it "is not in an active journey when the user has touched out" do
        oystercard.touch_in(entry_station)
        oystercard.touch_out(exit_station)
        expect(oystercard).to_not be_in_journey
      end

      it "deducts the journey fare once the user touches out" do
        oystercard.touch_in(entry_station)
        expect{ oystercard.touch_out(exit_station) }.to change{ oystercard.balance }.by(-1)
      end

      it "stores a journey(entry and exit stations) after you've touched out" do
        oystercard.touch_in(entry_station)
        oystercard.touch_out(exit_station)
        expect(oystercard.journey_history).to include(journey)
      end
    end

    context "without adequate funds for travel" do
      it "does not allow you to touch in when below the minimum fare" do
        expect { oystercard.touch_in(entry_station) }.to raise_error "Too low funds"
      end
    end

  end
end
