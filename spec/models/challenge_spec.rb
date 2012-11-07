require 'spec_helper'

describe Challenge do
  it "challenge can tell if it is open" do
    create(:challenge, closes_at: 1.day.from_now).should_not be_closed
    create(:challenge, closes_at: 1.day.ago).should be_closed
  end
end
