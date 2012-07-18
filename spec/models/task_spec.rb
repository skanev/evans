require 'spec_helper'

describe Task do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:description) }
  it { should validate_numericality_of(:max_points) }

  it { should have_many(:solutions) }

  it "can tell whether it is closed" do
    Factory(:task).should_not be_closed
    Factory(:closed_task).should be_closed
  end

  describe "restrictions" do
    it "has no restrictions by default" do
      create(:task).restrictions_hash.should eq Hash.new
    end

    it "validates that restrictions contains a yaml hash" do
      invalid_yaml = "a:\n  b:\n c:"

      Task.new(restrictions: invalid_yaml).should have_error_on(:restrictions)
      Task.new(restrictions: "3").should have_error_on(:restrictions)
      Task.new(restrictions: "").should have_error_on(:restrictions)
    end

    it "can tell whether it has restrictions" do
      Task.new.should_not have_restrictions
      Task.new(restrictions_hash: {'no_semicolons' => true}).should have_restrictions
    end
  end
end
