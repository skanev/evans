require 'spec_helper'

describe Task do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:description) }

  it { should have_many(:solutions) }

  it "can tell whether it is closed" do
    Factory(:task).should_not be_closed
    Factory(:closed_task).should be_closed
  end

  it "has no restrictions by default" do
    create(:task).restrictions.should eq Hash.new
  end
end
