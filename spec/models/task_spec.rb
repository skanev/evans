require 'spec_helper'

describe Task do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:description) }
  it { should validate_presence_of(:max_points) }
  it { should validate_numericality_of(:max_points) }

  it { should have_many(:solutions) }

  it "can tell whether it is closed" do
    expect(create(:open_task)).to_not be_closed
    expect(create(:closed_task)).to be_closed
  end

  it "amounts to six points by default" do
    expect(create(:task).max_points).to eq 6
  end

  it "can retrieve only checked tasks" do
    checked = create :task, checked: true
    create :task, checked: false

    expect(Task.checked).to eq [checked]
  end

  it "can retrieve only visible tasks" do
    visible = create :task, hidden: false
    create :task, hidden: true

    expect(Task.visible).to eq [visible]
  end

  it "can retrieve tasks in chronological order" do
    second = create :task, created_at: 1.day.ago
    first  = create :task, created_at: 2.days.ago

    expect(Task.in_chronological_order).to eq [first, second]
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
      expect(build(:closed_task)).to have_visible_solutions
    end
  end

  describe "restrictions" do
    it "has no restrictions by default" do
      expect(create(:task).restrictions_hash).to eq Hash.new
    end

    it "validates that restrictions contains a yaml document" do
      invalid_yaml = "a:\n  b:\n c:"

      expect(Task.new(restrictions: invalid_yaml)).to have_error_on(:restrictions)
    end

    it "can tell whether it has restrictions" do
      expect(Task.new).to_not have_restrictions
      expect(Task.new(restrictions_hash: {'no_semicolons' => true})).to have_restrictions
    end
  end

  describe "finding the next unscored solution" do
    it "returns the first unchecked solution" do
      task = create :manually_scored_task

      scored = create :solution, task: task, points: 0
      first  = create :solution, task: task
      second = create :solution, task: task

      expect(Task.next_unscored_solution(task.id)).to eq first
    end

    it "returns nil when there are no unchecked solutions" do
      task = create :manually_scored_task

      expect(Task.next_unscored_solution(task.id)).to be_nil
    end
  end
end
