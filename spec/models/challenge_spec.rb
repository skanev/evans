require 'spec_helper'

describe Challenge do
  it "challenge can tell if it is open" do
    expect(create(:challenge, closes_at: 1.day.from_now)).to_not be_closed
    expect(create(:challenge, closes_at: 1.day.ago)).to be_closed
  end

  it "can fetch all records, sorted in chronological order" do
    first  = create :challenge, created_at: 2.days.ago
    second = create :challenge, created_at: 1.day.ago

    expect(Challenge.in_chronological_order).to eq [first, second]
  end

  it "can fetch all visible records, sorted in chronological order" do
    first  = create :visible_challenge, created_at: 3.days.ago
    create :hidden_challenge, created_at: 2.days.ago
    second = create :visible_challenge, created_at: 1.day.ago

    expect(Challenge.visible).to eq [first, second]
  end
end
