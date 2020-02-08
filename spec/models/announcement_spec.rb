require 'spec_helper'

describe Announcement do
  it "paginates announcements in reverse chronological order" do
    second = create :announcement, created_at: 2.days.ago
    first  = create :announcement, created_at: 1.day.ago

    allow(Announcement).to receive(:per_page).and_return(1)

    expect(Announcement.page(1)).to eq [first]
    expect(Announcement.page(2)).to eq [second]
  end

  it "retuns the latest announcements" do
    second = create :announcement, created_at: 2.days.ago
    first  = create :announcement, created_at: 1.day.ago

    expect(Announcement.latest(1)).to eq [first]
  end
end
