require 'spec_helper'

describe TasksHelper do
  describe "#show_results?(task)" do
    let(:task) { double 'task' }

    it "shows results for checked tasks" do
      allow(task).to receive(:checked?).and_return(true)
      expect(helper.show_results?(task)).to be true
    end

    it "shows results for unchecked tasks to admins" do
      allow(task).to receive(:checked?).and_return(false)
      allow(view).to receive(:admin?).and_return(true)

      expect(helper.show_results?(task)).to be true
    end

    it "does not show results for unchecked tasks to non-admins" do
      allow(task).to receive(:checked?).and_return(false)
      allow(view).to receive(:admin?).and_return(false)

      expect(helper.show_results?(task)).to be false
    end
  end
end
