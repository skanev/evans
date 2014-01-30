require 'spec_helper'

describe UserOverview do
  let(:user) { double }
  let(:user_overview) { UserOverview.new user }
  let(:topic) { create :topic }
  let(:reply) { create :reply, topic: topic }

  before do
    user.stub(:topics).and_return [topic]
    user.stub(:replies).and_return [reply]
    user.stub :name
    user.stub :github
  end

  it 'delegates to user' do
    user_overview.name.should eq user.name
    user_overview.github.should eq user.github
  end

  it "can compile a hash of user's replies grouped by topic" do
    topic_replies = user_overview.topic_replies
    topic_replies.count.should eq 1
    topic_replies.keys.should include topic
    topic_replies.values[0].should include reply
  end
end