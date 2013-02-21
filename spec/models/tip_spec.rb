require 'spec_helper'

describe Tip do
  let(:tip) { double }

  it "suggest default value for published_at if there are no tips" do
    Tip.default_new_pushlied_at.to_i.should eq Time.now.to_i
  end

  it "suggest default value for published_at if there are tips" do
    first  = create :tip, published_at: 2.days.ago

    Tip.default_new_pushlied_at.to_i.should eq (Time.now - 1.day).to_i
  end
end
