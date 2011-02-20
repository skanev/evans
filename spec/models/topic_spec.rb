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

  it "supports paging" do
    second = Topic.make :created_at => 2.day.ago
    first  = Topic.make :created_at => 1.days.ago

    Topic.stub :per_page => 1

    Topic.page(1).should == [first]
    Topic.page(2).should == [second]
  end
end
