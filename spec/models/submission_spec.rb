require 'spec_helper'

describe Submission do
  let(:user) { create :user }
  let(:task) { create :open_task }

  before do
    Language.stub parsing?: true
  end

  it "creates a new solution and revision for the given user and task" do
    submit user, task, 'code'

    solution = Solution.where(user_id: user.id, task_id: task.id).first
    solution.should be_present
    solution.should have(1).revisions
    solution.revisions.first.code.should eq 'code'
  end

  it "updates the current solution and creates a new revision if already submitted" do
    solution = create :solution_with_revisions, user: user, task: task, code: 'old code'

    submit user, task, 'new code'

    solution.reload
    solution.code.should eq 'new code'
    solution.should have(2).revisions
    solution.revisions.last.code.should eq 'new code'
  end

  it "indicates if the submission is successful" do
    submission = Submission.new(user, task, 'new code')
    submission.submit.should be_true
  end

  it "indicates if the submission is unsuccessful due to closed task" do
    task = create :closed_task

    submission = Submission.new(user, task, 'code')
    submission.submit.should be_false
    submission.should have_error_on :base
  end

  it "indicates if the submission is unsuccessful due to no code" do
    submission = Submission.new(user, task, '')
    submission.submit.should be_false
    submission.should have_error_on :code
  end

  it "indicates if the submission is unsuccessful due to invalid code" do
    Language.stub parsing?: false

    submission = Submission.new(user, task, 'unparsable code')
    submission.submit.should be_false
    submission.should have_error_on :code
  end

  it "does not update the solution after the task is closed" do
    task = create(:closed_task)
    solution = create :solution_with_revisions, task: task, user: user, code: 'old code'

    submit user, task, 'new code'

    solution.reload
    solution.code.should eq 'old code'
  end

  it "does not create a new revision if the user submits the same code" do
    solution = create :solution_with_revisions, task: task, user: user, code: 'original code'

    expect do
      submit user, task, 'original code'
    end.not_to change(Revision, :count)
  end

  describe "task with restrictions" do
    it "adds restrictions as violations" do
      code       = 'foo;bar'
      task       = create :open_task, restrictions_hash: {'no_semicolons' => true}
      submission = Submission.new user, task, code

      submission.submit.should be_false
      submission.should have_error_on :code
      submission.should be_violating_restrictions
      submission.violations.should include('You have a semicolon')
    end
  end

  describe "(skeptic)" do
    let(:critic) { double.as_null_object }

    before do
      Skeptic::Critic.stub new: critic
    end

    it "invokes skeptic on the code" do
      critic.should_receive(:criticize).with('code')
      submit user, task, 'code'
    end

    it "doesn't invoke skeptic on code with syntax errors" do
      Language.stub parsing?: false
      critic.should_not_receive(:criticize)
      submit user, task, 'code'
    end
  end

  def submit(user, task, code)
    submission = Submission.new user, task, code
    submission.submit
  end
end
