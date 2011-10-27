require 'spec_helper'

describe Feed do
  it "aggregates comments" do
    comment   = create(:comment)
    commenter = comment.user
    solution  = comment.solution
    task      = solution.task

    item = last_activity

    item.user_id.should      eq commenter.id
    item.user_name.should    eq commenter.name
    item.target_id.should    eq solution.id
    item.secondary_id.should eq task.id
    item.subject.should      eq task.name
    item.kind.should         eq :comment
    item.happened_at.should  be_within(1.second).of(comment.created_at)
  end

  it "aggregates submitted solutions" do
    solution = create(:solution)
    user     = solution.user
    task     = solution.task

    item = last_activity

    item.user_id.should      eq user.id
    item.user_name.should    eq user.name
    item.target_id.should    eq solution.id
    item.secondary_id.should eq task.id
    item.subject.should      eq task.name
    item.kind.should         eq :solution
    item.happened_at.should  be_within(1.second).of(solution.updated_at)
  end

  def last_activity
    Feed.new.enum_for(:each_activity).first
  end
end
