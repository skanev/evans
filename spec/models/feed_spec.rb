require 'spec_helper'

describe Feed do
  it "aggregates comments" do
    comment   = create(:comment)
    commenter = comment.user
    solution  = comment.solution
    task      = solution.task

    item = last_activity

    expect(item.user_id).to          eq commenter.id
    expect(item.user_name).to        eq commenter.name
    expect(item.target_id).to        eq solution.id
    expect(item.secondary_id).to     eq task.id
    expect(item.subject).to          eq task.name
    expect(item.kind).to             eq :comment

    expect(item.happened_at.to_s(:db)).to eq comment.created_at.to_s(:db)
  end

  it "aggregates submitted solutions" do
    solution = create(:solution)
    user     = solution.user
    task     = solution.task

    item = last_activity

    expect(item.user_id).to          eq user.id
    expect(item.user_name).to        eq user.name
    expect(item.target_id).to        eq solution.id
    expect(item.secondary_id).to     eq task.id
    expect(item.subject).to          eq task.name
    expect(item.kind).to             eq :solution

    expect(item.happened_at.to_s(:db)).to eq solution.updated_at.to_s(:db)
  end

  def last_activity
    Feed.new.enum_for(:each_activity).first
  end
end
