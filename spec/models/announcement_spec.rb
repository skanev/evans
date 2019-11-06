require 'spec_helper'

describe Announcement do
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:body) }

  it "paginates announcements in reverse chronological order" do
    second = create :announcement, created_at: 2.days.ago
    first  = create :announcement, created_at: 1.day.ago

    Announcement.stub per_page: 1

    expect(Announcement.page(1)).to eq [first]
    expect(Announcement.page(2)).to eq [second]
  end

  it "retuns the latest announcements" do
    second = create :announcement, created_at: 2.days.ago
    first  = create :announcement, created_at: 1.day.ago

    expect(Announcement.latest(1)).to eq [first]
  end
end
