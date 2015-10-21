require 'oystercard'

describe Oystercard do

  subject(:oystercard) { described_class.new(journey: journey_klass) }

    let(:entry_station) { double(:entry_station, zone: 1) }
    let(:exit_station) { double(:exit_station, zone: 2) }

    let(:journey) { instance_spy("Journey", entry_station: entry_station, exit_station: exit_station) }

    let(:journey_klass) { class_spy("Journey", new: journey) }

  it "has a balance of £0" do
    expect(oystercard.balance).to eq(0)
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

    context "with adequate funds for travel" do

      before do
        oystercard.top_up(1)
        allow(journey).to receive(:end).with(exit_station)
      end

      it "remembers the entry station after touching in" do
        oystercard.touch_in(entry_station)
        expect(journey_klass).to have_received(:new).with(entry_station)
      end

      it "remembers the exit station after touching out" do
        oystercard.touch_in(entry_station)
        oystercard.touch_out(exit_station)
        expect(journey).to have_received(:end).with(exit_station)
      end

      it "deducts the journey fare once the user touches out" do
        oystercard.touch_in(entry_station)
        expect{ oystercard.touch_out(exit_station) }.to change{ oystercard.balance }.by(-1)
      end

      it "stores a journey after you've touched in" do
        oystercard.touch_in(entry_station)
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
