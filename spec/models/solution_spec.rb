require 'spec_helper'

describe Solution do
  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:task_id) }
  it { should validate_presence_of(:code) }
  it { Factory(:solution).should validate_uniqueness_of(:user_id).scoped_to(:task_id) }

  it { should belong_to(:user) }
  it { should belong_to(:task) }

  describe "submitting" do
    let(:user) { User.make }
    let(:task) { Task.make }

    it "creates a new solution for the given user and task" do
      Solution.submit user, task, 'code'

      Solution.exists?(:user_id => user.id, :task_id => task.id, :code => 'code').should be_true
    end

    it "updates the current solution if it exists" do
      solution = Solution.make :user => user, :task => task, :code => 'old code'

      Solution.submit user, task, 'new code'

      solution.reload
      solution.code.should == 'new code'
    end

    it "returns true on success" do
      Solution.submit(user, task, 'new code').should be_true
    end

    it "returns false on failure" do
      Solution.submit(user, task, nil).should be_false
    end
  end
end
