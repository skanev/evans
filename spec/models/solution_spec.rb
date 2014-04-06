require 'spec_helper'

describe Solution do
  it { should validate_presence_of :user_id }
  it { should validate_presence_of :task_id }
  it { create(:solution).should validate_uniqueness_of(:user_id).scoped_to(:task_id) }

  it { should belong_to(:user) }
  it { should belong_to(:task) }

  it "can find all the solutions for task" do
    task = create :task
    solution = create :solution, task: task

    Solution.for_task(task.id).should eq [solution]
  end

  it "can find the number of rows in the code" do
    create(:solution_with_revisions, code: 'print("baba")').rows.should eq 1
    create(:solution_with_revisions, code: "1\n2").rows.should eq 2
    create(:solution_with_revisions, code: "1\n2\n3").rows.should eq 3
  end

  it "delegates max_points to task" do
    solution = build(:solution, passed_tests: 10, failed_tests: 0)

    solution.max_points.should eq solution.task.max_points
  end

  it "can tell whether it is manually scored" do
    solution = build :solution, task: build(:manually_scored_task)
    solution.should be_manually_scored
  end

  it "can calculate the total points for a task" do
    build(:solution, points: nil, adjustment: 0).total_points.should eq 0
    build(:solution, points: 6, adjustment: 3).total_points.should eq 9
    build(:solution, points: 6, adjustment: -2).total_points.should eq 4
    build(:solution, points: 1, adjustment: -2).total_points.should eq 0
  end

  it "can tell the latest revision" do
    solution = create :solution
    first    = create :revision, solution: solution
    second   = create :revision, solution: solution

    solution.last_revision.should eq second
  end

  it "can tell the code of the lastest revision" do
    solution = create :solution
    create :revision, solution: solution, code: 'first revision'
    create :revision, solution: solution, code: 'second revision'

    solution.code.should eq 'second revision'
  end

  describe "looking up the code of an existing solution" do
    let(:user) { create :user }
    let(:task) { create :task }

    it "retuns the code as a string" do
      create :solution_with_revisions, code: 'code', user: user, task: task
      Solution.code_for(user, task).should eq 'code'
    end

    it "returns nil if the no solution submitted by this user" do
      Solution.code_for(user, task).should be_nil
    end
  end

  describe "visibility" do
    let(:task) { raise NotImplemented }
    let(:solution) { create :solution, task: task }
    let(:a_student) { create :user }
    let(:author) { solution.user }
    let(:admin) { create :admin }

    context "when task is hidden" do
      let(:task) { create :hidden_task }

      it "is not visible to unauthenticated users" do
        solution.should_not be_visible_to nil
      end

      it "is not visible to students" do
        solution.should_not be_visible_to a_student
      end

      it "is not visible to its owner" do
        solution.should_not be_visible_to author
      end

      it "is visible to admins" do
        solution.should be_visible_to admin
      end
    end

    context "when task is open" do
      let(:task) { create :open_task }

      it "is not visible to unauthenticated users" do
        solution.should_not be_visible_to nil
      end

      it "is not visible to students" do
        solution.should_not be_visible_to a_student
      end

      it "is visible to its author" do
        solution.should be_visible_to author
      end

      it "is visible to admins" do
        solution.should be_visible_to admin
      end
    end

    context "when task is closed" do
      let(:task) { create :closed_task }

      it "is visible to unauthenticated users" do
        solution.should be_visible_to nil
      end

      it "is visible to students" do
        solution.should be_visible_to a_student
      end

      it "is visible to its author" do
        solution.should be_visible_to author
      end

      it "is visible to admins" do
        solution.should be_visible_to admin
      end
    end

    context "when task is closed, but hidden" do
      let(:task) { create :closed_task, hidden: true }

      it "is not visible to unauthenticated users" do
        solution.should_not be_visible_to nil
      end

      it "is not visible to students" do
        solution.should_not be_visible_to a_student
      end

      it "is not visible to its author" do
        solution.should_not be_visible_to author
      end

      it "is visible to admins" do
        solution.should be_visible_to admin
      end
    end
  end

  describe "commenting" do
    context "when task is open" do
      let(:solution) { build :solution, task: build(:open_task) }

      it "is available to its author" do
        solution.should be_commentable_by solution.user
      end

      it "is available to admins" do
        solution.should be_commentable_by build(:admin)
      end

      it "is not available to other users" do
        solution.should_not be_commentable_by build(:user)
      end

      it "is not available to unauthenticated people" do
        solution.should_not be_commentable_by nil
      end
    end

    context "when task is closed" do
      let(:solution) { build :solution, task: build(:closed_task) }

      it "is available to all users" do
        solution.should be_commentable_by solution.user
        solution.should be_commentable_by build(:admin)
        solution.should be_commentable_by build(:user)
      end

      it "is not available to unauthenticated people" do
        solution.should_not be_commentable_by nil
      end
    end
  end

  describe "automatic scoring" do
    [
      [18, 0, 6, 6],
      [17, 1, 6, 6],
      [16, 2, 6, 5],
      [12, 6, 6, 4],
      [10, 0, 8, 8],
    ].each do |passed, failed, max_points, points|
      it "assigns #{points} points for #{passed} passed and #{failed} failed tests in a task that ammounts to #{max_points} points" do
        Solution.calculate_points(passed, failed, max_points).should eq points
      end
    end

    it "assigns 0 points if the solution is not checked" do
      Solution.calculate_points(0, 0, 6).should eq 0
    end
  end

  describe "scoring" do
    let(:solution) { create :solution, task: task }
    context "when automatically scored" do
      let(:task) { create :automatically_scored_task }

      it "allows setting an adjustment" do
        solution.update_score adjustment: 2
        solution.adjustment.should eq 2
      end

      it "disallows setting points directly" do
        solution.update_score points: 5
        solution.points.should_not eq 5
      end
    end

    context "when manually scored" do
      let(:task) { create :manually_scored_task }

      it "allows setting an adjustment" do
        solution.update_score adjustment: 2
        solution.adjustment.should eq 2
      end

      it "allows setting points directly" do
        solution.update_score points: 5
        solution.points.should eq 5
      end
    end
  end
end
