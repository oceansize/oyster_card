require 'oystercard'

describe Oystercard do

  it "has a balance" do
    oystercard = Oystercard.new
    expect(oystercard.balance).to eq(0)
  end

end
