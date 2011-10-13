require 'spec_helper'

describe Topic do
  it { should have_many(:replies) }
  it { should validate_presence_of(:title) }

  it "does not allow mass reassignment of user_id" do
    original, modified = FactoryGirl.create(:user), FactoryGirl.create(:user)
    topic = FactoryGirl.create :topic, :user => original

    topic.update_attributes! :user_id => modified.id

    topic.reload.user.should == original
  end

  it "supports paging, ordering in reverse chronological order of the last post" do
    create_topic_with_last_reply_at = lambda do |timestamp|
      FactoryGirl.create(:reply, :created_at => timestamp).topic
    end

    second = create_topic_with_last_reply_at.call 2.days.ago
    first  = create_topic_with_last_reply_at.call 1.day.ago

    Topic.stub :per_page => 1

    Topic.boards_page(1).should == [first]
    Topic.boards_page(2).should == [second]
  end

  it "can paginate its replies" do
    topic  = FactoryGirl.create :topic, :created_at => 3.days.ago
    first  = FactoryGirl.create :reply, :topic => topic, :created_at => 2.days.ago
    second = FactoryGirl.create :reply, :topic => topic, :created_at => 1.day.ago

    Reply.stub :per_page => 1

    topic.replies_on_page(1).should == [first]
    topic.replies_on_page(2).should == [second]
  end

  it "can be edited by its owner or by an admin" do
    topic = FactoryGirl.create :topic

    topic.should be_editable_by(topic.user)
    topic.should be_editable_by(Factory(:admin))

    topic.should_not be_editable_by(Factory(:user))
    topic.should_not be_editable_by(nil)
  end

  it "can tell how many pages of replies it has" do
    topic_with_replies = lambda do |count|
      topic = FactoryGirl.create :topic
      count.times { FactoryGirl.create :reply, :topic => topic }
      topic.reload
    end

    Reply.stub :per_page => 2

    topic_with_replies[0].pages_of_replies.should == 1
    topic_with_replies[2].pages_of_replies.should == 1
    topic_with_replies[3].pages_of_replies.should == 2
  end

  it "gives its own title when asked for the containing topic's title" do
    Topic.new(:title => 'Title').topic_title.should == 'Title'
  end

  describe "last post on boards page" do
    let(:topic_with_last_post) { Topic.boards_page(1).first }

    it "is the topic itself initially" do
      Timecop.freeze(Time.now) do
        topic = FactoryGirl.create :topic

        topic_with_last_post.last_poster.should == topic.user
        topic_with_last_post.last_post_at.should == Time.zone.now
      end
    end

    it "is updated whenever a new reply is created" do
      topic = nil

      Timecop.freeze(1.day.ago) do
        topic = FactoryGirl.create :topic
      end

      Timecop.freeze(1.hour.ago) do
        reply = FactoryGirl.create :reply, :topic => topic

        topic_with_last_post.last_post_at.should == Time.zone.now
        topic_with_last_post.last_poster.should == reply.user
      end
    end
  end

  it_behaves_like 'Post' do
    let(:post) { Factory(:topic) }
    let(:starred_post) { Factory(:topic, :starred => true) }
  end
end
