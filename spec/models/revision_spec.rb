require 'spec_helper'

describe Revision do
  it { should validate_presence_of :code }

  it "orders the comments chronologically" do
    revision = create :revision

    second = create :comment, revision: revision, created_at: 1.day.ago
    first  = create :comment, revision: revision, created_at: 2.days.ago

    revision.comments.should eq [first, second]
  end
end
