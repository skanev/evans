require 'spec_helper'

describe Topic do
  it { should have_many(:replies) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:body) }
  it { should validate_presence_of(:user_id) }

  it "does not allow mass reassignment of user_id" do
    original, modified = User.make, User.make
    topic = Topic.make :user => original

    topic.update_attributes! :user_id => modified.id

    topic.reload.user.should == original
  end

  it "supports paging, ordering in reverse chronological order of the last post" do
    create_topic_with_last_reply_at = lambda do |timestamp|
      Reply.make(:created_at => timestamp).topic
    end

    second = create_topic_with_last_reply_at.call 2.days.ago
    first  = create_topic_with_last_reply_at.call 1.day.ago

    Topic.stub :per_page => 1

    Topic.boards_page(1).should == [first]
    Topic.boards_page(2).should == [second]
  end

  it "can paginate its replies" do
    topic  = Topic.make :created_at => 3.days.ago
    first  = Reply.make :topic => topic, :created_at => 2.days.ago
    second = Reply.make :topic => topic, :created_at => 1.day.ago

    Reply.stub :per_page => 1

    topic.replies_on_page(1).should == [first]
    topic.replies_on_page(2).should == [second]
  end

  it "can be edited by its owner or by an admin" do
    topic = Topic.make

    topic.can_be_edited_by?(topic.user).should be_true
    topic.can_be_edited_by?(Factory(:admin)).should be_true

    topic.can_be_edited_by?(Factory(:user)).should be_false
    topic.can_be_edited_by?(nil).should be_false
  end

  it "can tell how many pages of replies it has" do
    topic_with_replies = lambda do |count|
      topic = Topic.make
      count.times { Reply.make :topic => topic }
      topic.reload
    end

    Reply.stub :per_page => 2

    topic_with_replies[0].pages_of_replies.should == 1
    topic_with_replies[2].pages_of_replies.should == 1
    topic_with_replies[3].pages_of_replies.should == 2
  end

  describe "last post on boards page" do
    let(:topic_with_last_post) { Topic.boards_page(1).first }

    it "is the topic itself initially" do
      Timecop.freeze(Time.now) do
        topic = Topic.make

        topic_with_last_post.last_poster.should == topic.user
        topic_with_last_post.last_post_at.should == Time.zone.now
      end
    end

    it "is updated whenever a new reply is created" do
      topic = nil

      Timecop.freeze(1.day.ago) do
        topic = Topic.make
      end

      Timecop.freeze(1.hour.ago) do
        reply = Reply.make :topic => topic

        topic_with_last_post.last_post_at.should == Time.zone.now
        topic_with_last_post.last_poster.should == reply.user
      end
    end
  end
end
