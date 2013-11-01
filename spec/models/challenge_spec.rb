require 'spec_helper'

describe Challenge do
  it { should validate_presence_of :name }
  it { should validate_presence_of :description }

  it "challenge can tell if it is open" do
    create(:challenge, closes_at: 1.day.from_now).should_not be_closed
    create(:challenge, closes_at: 1.day.ago).should be_closed
  end

  it "can fetch all records, sorted in chronological order" do
    older = create :challenge, created_at: 2.days.ago
    newer  = create :challenge, created_at: 1.day.ago

    Challenge.in_chronological_order.should eq [older, newer]
  end

  it "can fetch all visible records, sorted in chronological order" do
    older = create :visible_challenge, created_at: 3.days.ago
    create :hidden_challenge, created_at: 2.days.ago
    newer  = create :visible_challenge, created_at: 1.day.ago

    Challenge.visible.should eq [older, newer]
  end
end
