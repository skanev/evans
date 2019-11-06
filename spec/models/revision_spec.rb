require 'spec_helper'

describe Revision do
  it "orders the comments chronologically" do
    revision = create :revision

    second = create :comment, revision: revision, created_at: 1.day.ago
    first  = create :comment, revision: revision, created_at: 2.days.ago

    expect(revision.comments).to eq [first, second]
  end
end
