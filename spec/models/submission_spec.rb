require 'spec_helper'

describe Submission do
  let(:user) { create :user }
  let(:task) { create :task }

  it "creates a new solution for the given user and task" do
    submit user, task, 'code'

    Solution.exists?(user_id: user.id, task_id: task.id, code: 'code').should be_true
  end

  it "updates the current solution if it exists" do
    solution = create :solution, user: user, task: task, code: 'old code'

    submit user, task, 'new code'

    solution.reload
    solution.code.should == 'new code'
  end

  it "indicates if the submission is successful" do
    submission = Submission.new(user, task, 'new code')
    submission.submit.should be_true
  end

  it "indicates if the submission is unsuccessful" do
    submission = Submission.new(user, task, '')
    submission.submit.should be_false
  end

  it "does not update the solution after the task is closed" do
    task = create(:closed_task)
    solution = create(:solution, task: task, user: user, code: 'old code')

    submit user, task, 'new code'

    solution.reload
    solution.code.should == 'old code'
  end

  describe "task with restrictions" do
    it "can run with skeptic" do
      code       = 'foo;bar'
      task       = create :task, restrictions_hash: {'no_semicolons' => true}
      submission = Submission.new user, task, code

      submission.submit.should be_false
      submission.should be_violating_restrictions
      submission.violations.should include('You have a semicolon')
    end
  end

  def submit(user, task, code)
    submission = Submission.new user, task, code
    submission.submit
  end
end
