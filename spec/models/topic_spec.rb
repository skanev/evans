require 'spec_helper'

describe Topic do
  it { should have_many(:replies) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:body) }
  it { should validate_presence_of(:user) }

  it "does not allow mass reassignment of user_id" do
    original, modified = User.make, User.make
    topic = Topic.make :user => original

    topic.update_attributes! :user_id => modified.id

    topic.reload.user.should == original
  end

  it "supports paging, ordering in reverse chronological order of the last post" do
    first  = Topic.make :last_post_at => 1.day.ago
    second = Topic.make :last_post_at => 2.days.ago

    Topic.stub :per_page => 1

    Topic.page(1).should == [first]
    Topic.page(2).should == [second]
  end

  it "can paginate its replies" do
    topic  = Topic.make :created_at => 3.days.ago
    first  = Reply.make :topic => topic, :created_at => 2.days.ago
    second = Reply.make :topic => topic, :created_at => 1.day.ago

    Reply.stub :per_page => 1

    topic.replies_on_page(1).should == [first]
    topic.replies_on_page(2).should == [second]
  end

  describe "last post" do
    it "is the topic itself initially" do
      Timecop.freeze do
        topic = Topic.make

        topic.last_poster.should == topic.user
        topic.last_post_at.should == Time.now
      end
    end

    it "is updated whenever a new reply is created" do
      topic = nil

      Timecop.freeze(1.day.ago) do
        topic = Topic.make :last_post_at => 1.day.ago
      end

      Timecop.freeze do
        reply = Reply.make :topic => topic

        topic.reload
        topic.last_post_at.should == Time.now
        topic.last_poster.should == reply.user
      end
    end
  end
end
