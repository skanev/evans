require 'spec_helper'

describe TasksHelper do
  describe "#show_results?(task)" do
    let(:task) { double 'task' }

    it "shows results for checked tasks" do
      task.stub checked?: true
      helper.show_results?(task).should be_true
    end

    it "shows results for unchecked tasks to admins" do
      task.stub checked?: false
      view.stub admin?: true

      helper.show_results?(task).should be_true
    end

    it "does not show results for unchecked tasks to non-admins" do
      task.stub checked?: false
      view.stub admin?: false

      helper.show_results?(task).should be_false
    end
  end
end
