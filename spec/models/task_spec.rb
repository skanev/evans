require 'spec_helper'

describe Task do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:description) }
  it { should validate_presence_of(:max_points) }
  it { should validate_numericality_of(:max_points) }

  it { should have_many(:solutions) }

  it "can tell whether it is closed" do
    create(:open_task).should_not be_closed
    create(:closed_task).should be_closed
  end

  it "amounts to six points by default" do
    create(:task).max_points.should eq 6
  end

  it "can retrieve only checked tasks" do
    checked = create :task, checked: true
    create :task, checked: false

    Task.checked.should eq [checked]
  end

  it "can retrieve only visible tasks" do
    visible = create :task, hidden: false
    create :task, hidden: true

    Task.visible.should eq [visible]
  end

  it "can retrieve tasks in chronological order" do
    second = create :task, created_at: 1.day.ago
    first  = create :task, created_at: 2.days.ago

    Task.in_chronological_order.should eq [first, second]
  end

  describe "(solutions visiblity)" do
    it "does not have visible solutions if open" do
      build(:open_task).should_not have_visible_solutions
    end

    it "does not have visible solutions if hidden" do
      build(:hidden_task).should_not have_visible_solutions
    end

    it "does not have visible solutions if closed, but hidden" do
      build(:closed_task, hidden: true).should_not have_visible_solutions
    end

    it "has visible solutions if closed and not hidden" do
      build(:closed_task).should have_visible_solutions
    end
  end

  describe "restrictions" do
    it "has no restrictions by default" do
      create(:task).restrictions_hash.should eq Hash.new
    end

    it "validates that restrictions contains a yaml document" do
      invalid_yaml = "a:\n  b:\n c:"

      Task.new(restrictions: invalid_yaml).should have_error_on(:restrictions)
    end

    it "can tell whether it has restrictions" do
      Task.new.should_not have_restrictions
      Task.new(restrictions_hash: {'no_semicolons' => true}).should have_restrictions
    end
  end

  describe "finding the next unscored solution" do
    it "returns the first unchecked solution" do
      task = create :manually_scored_task

      scored = create :solution, task: task, points: 0
      first  = create :solution, task: task
      second = create :solution, task: task

      Task.next_unscored_solution(task.id).should eq first
    end

    it "returns nil when there are no unchecked solutions" do
      task = create :manually_scored_task

      Task.next_unscored_solution(task.id).should be_nil
    end
  end
end
