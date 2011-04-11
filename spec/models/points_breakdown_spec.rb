require 'spec_helper'

describe PointsBreakdown do
  let(:user) { User.make }

  it "can tell whether a user has starred posts" do
    user = User.make
    breakdown = PointsBreakdown.new user

    breakdown.should_not be_having_starred_posts

    topic = Topic.make :user => user, :starred => true
    breakdown.should be_having_starred_posts
  end

  it "can iterate all starred posts a user has" do
    topic = Topic.make :user => user, :starred => true
    reply = Reply.make :user => user, :starred => true

    breakdown = PointsBreakdown.new user

    breakdown.enum_for(:each_starred_post_with_title).map(&:first).should =~ [topic, reply]
  end

  it "yields the topic title when iterating topics" do
    Topic.make :user => user, :starred => true, :title => 'Topic'

    breakdown = PointsBreakdown.new user

    breakdown.enum_for(:each_starred_post_with_title).map(&:second).should =~ ['Topic']
  end

  it "yields the title of the reply's topic when iterating replies" do
    topic = Topic.make :title => 'Topic with replies'
    Reply.make :user => user, :topic => topic, :starred => true

    breakdown = PointsBreakdown.new user

    breakdown.enum_for(:each_starred_post_with_title).map(&:second).should =~ ['Topic with replies']
  end
end
