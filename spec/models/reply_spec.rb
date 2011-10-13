require 'spec_helper'

describe Reply do
  it { should belong_to(:topic) }
  it { should validate_presence_of(:body) }
  it { should_not allow_mass_assignment_of(:topic_id) }

  it "can be edited by its owner or by an admin" do
    reply = FactoryGirl.create :reply

    reply.should be_editable_by(reply.user)
    reply.should be_editable_by(Factory(:admin))

    reply.should_not be_editable_by(nil)
    reply.should_not be_editable_by(Factory(:user))
  end

  it "can tell on which page of the topic it is" do
    topic  = FactoryGirl.create :topic
    first  = FactoryGirl.create :reply, :topic => topic
    second = FactoryGirl.create :reply, :topic => topic
    third  = FactoryGirl.create :reply, :topic => topic

    Reply.stub :per_page => 2

    first.page_in_topic.should == 1
    second.page_in_topic.should == 1
    third.page_in_topic.should == 2
  end

  it "gives the title of its topic when asked for the containing topic's title" do
    topic = FactoryGirl.create :topic, :title => 'Topic title'
    reply = FactoryGirl.create :reply, :topic => topic

    reply.topic_title.should == 'Topic title'
  end

  it_behaves_like 'Post' do
    let(:post) { FactoryGirl.create :reply }
    let(:starred_post) { FactoryGirl.create :reply, :starred => true }
  end
end
