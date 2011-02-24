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
end
