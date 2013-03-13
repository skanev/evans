require 'spec_helper'

describe Tip do
  it "suggest default value for published_at if there are no tips" do
    Timecop.freeze do
      Tip.default_new_published_at.should be_within(1.second).of(Time.now)
    end
  end

  it "suggest default value for published_at if there are tips" do
    Timecop.freeze(Time.now) do
      first = create :tip, published_at: 2.days.ago
      Tip.default_new_published_at.should be_within(1.second).of(1.day.ago)
    end
  end
end
