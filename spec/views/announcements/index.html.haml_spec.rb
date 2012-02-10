require 'spec_helper'

describe "announcements/index.html.haml" do

  describe "show RSS feed" do
    before do
      view.stub :admin? => false
      assign :announcements, announcements
    end

    it_behaves_like "has RSS feed" do
      let(:announcements) { Announcement.page 1 }
      let(:rss_url) { announcements_url(:rss) }
    end
  end

end
