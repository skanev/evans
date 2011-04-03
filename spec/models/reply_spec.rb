require 'spec_helper'

describe Reply do
  it { should belong_to(:topic) }
  it { should belong_to(:user) }

  it { should validate_presence_of(:body) }
  it { should validate_presence_of(:topic_id) }
  it { should validate_presence_of(:user_id) }

  it { should_not allow_mass_assignment_of(:user_id) }
  it { should_not allow_mass_assignment_of(:topic_id) }

  it "can be edited by its owner or by an admin" do
    reply = Reply.make

    reply.can_be_edited_by?(reply.user).should be_true
    reply.can_be_edited_by?(Factory(:admin)).should be_true

    reply.can_be_edited_by?(nil).should be_false
    reply.can_be_edited_by?(Factory(:user)).should be_false
  end

  it "can tell on which page of the topic it is" do
    topic  = Topic.make
    first  = Reply.make :topic => topic
    second = Reply.make :topic => topic
    third  = Reply.make :topic => topic

    Reply.stub :per_page => 2

    first.page_in_topic.should == 1
    second.page_in_topic.should == 1
    third.page_in_topic.should == 2
  end

  describe "syncronization with Post" do
    it "happens on create" do
      Timecop.freeze do
        reply = Reply.make

        post = Post.where(:topic_id => reply.topic_id).first
        post.should be_present
        post.attributes.slice(*Post::REPLY_ATTRIBUTES).should == reply.attributes.slice(*Post::REPLY_ATTRIBUTES)
      end
    end

    it "happens on update" do
      reply = Reply.make

      reply.update_attributes! :body => 'New body'

      post = Post.find_by_topic_id(reply.topic_id)
      post.body.should == 'New body'
    end
  end
end
