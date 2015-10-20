require "station"

describe Station do

  subject(:station) { described_class.new("Wapping", 1) }

  it "has a name" do
    expect(station.name).to eq("Wapping")
  end

  it "has a zone" do
    expect(station.zone).to eq(1)
  end
end
