require 'spec_helper'

describe Submission do
  let(:user) { create :user }
  let(:task) { create :open_task }

  before do
    Language.stub parsing?: true
    Language.stub can_lint?: false
  end

  it "creates a new solution and revision for the given user and task" do
    submit user, task, 'code'

    solution = Solution.where(user_id: user.id, task_id: task.id).first
    expect(solution).to be_present
    expect(solution).to have(1).revisions
    expect(solution.revisions.first.code).to eq 'code'
  end

  it "updates the current solution and creates a new revision if already submitted" do
    solution = create :solution_with_revisions, user: user, task: task, code: 'old code'

    submit user, task, 'new code'

    solution.reload
    expect(solution.code).to eq 'new code'
    expect(solution).to have(2).revisions
    expect(solution.revisions.last.code).to eq 'new code'
  end

  it "indicates if the submission is successful" do
    submission = Submission.new(user, task, 'new code')
    expect(submission.submit).to be true
  end

  it "indicates if the submission is unsuccessful due to closed task" do
    task = create :closed_task

    submission = Submission.new(user, task, 'code')
    expect(submission.submit).to be false
    expect(submission).to have_error_on :base
  end

  it "indicates if the submission is unsuccessful due to no code" do
    submission = Submission.new(user, task, '')
    expect(submission.submit).to be false
    expect(submission).to have_error_on :code
  end

  it "indicates if the submission is unsuccessful due to invalid code" do
    Language.stub parsing?: false

    submission = Submission.new(user, task, 'unparsable code')
    expect(submission.submit).to be false
    expect(submission).to have_error_on :code
  end

  it "does not update the solution after the task is closed" do
    task = create(:closed_task)
    solution = create :solution_with_revisions, task: task, user: user, code: 'old code'

    submit user, task, 'new code'

    solution.reload
    expect(solution.code).to eq 'old code'
  end

  it "does not create a new revision if the user submits the same code" do
    solution = create :solution_with_revisions, task: task, user: user, code: 'original code'

    expect do
      submit user, task, 'original code'
    end.not_to change(Revision, :count)
  end

  describe "task with restrictions" do
    before do
      rubocop_config = Rails.root.join('spec/fixtures/files/rubocop-config.yml')

      Rails.application.config.stub rubocop_config_location: rubocop_config

      Language.stub can_lint?: true
    end

    it 'lints using the default configuration' do
      code       = 'foo;bar'
      task       = create :open_task
      submission = Submission.new user, task, code

      expect(submission.submit).to be false
      expect(submission).to have_error_on :code
      expect(submission).to be_violating_restrictions
      expect(submission.violations).to include('Do not use semicolons')
    end

    it 'lints with default and custom configuration when present' do
      code       = "foo;bar\n! test"
      task       = create :open_task, restrictions: <<-YAML.strip_heredoc
        Style/SpaceAfterNot:
          Enabled: true
      YAML
      submission = Submission.new user, task, code

      expect(submission.submit).to be false
      expect(submission).to have_error_on :code
      expect(submission).to be_violating_restrictions
      expect(submission.violations).to include('Do not use semicolons')
      expect(submission.violations).to include('Do not leave space between `!` and its argument')
    end
  end

  describe "(skeptic)" do
    before do
      Language.stub can_lint?: true
    end

    it "doesn't invoke the linter on code with syntax errors" do
      Language.stub parsing?: false
      Language.should_not_receive(:lint)
      submit user, task, 'code'
    end
  end

  def submit(user, task, code)
    submission = Submission.new user, task, code
    submission.submit
  end
end
