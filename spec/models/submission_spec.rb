require 'spec_helper'

describe Submission do
  let(:user) { FactoryGirl.create :user }
  let(:task) { FactoryGirl.create :task }

  it "creates a new solution for the given user and task" do
    submit user, task, 'code'

    Solution.exists?(:user_id => user.id, :task_id => task.id, :code => 'code').should be_true
  end

  it "updates the current solution if it exists" do
    solution = FactoryGirl.create :solution, :user => user, :task => task, :code => 'old code'

    submit user, task, 'new code'

    solution.reload
    solution.code.should == 'new code'
  end

  it "returns true on success" do
    submit(user, task, 'new code').should be_true
  end

  it "returns false on failure" do
    submit(user, task, nil).should be_false
  end

  it "does not update the solution after the task is closed" do
    task = Factory(:closed_task)
    solution = Factory(:solution, :task => task, :user => user, :code => 'old code')

    submit user, task, 'new code'

    solution.reload
    solution.code.should == 'old code'
  end

  def submit(user, task, code)
    submission = Submission.new user, task, code
    submission.submit
  end
end
