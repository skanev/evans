require 'spec_helper'
require 'uri'

describe "announcements/index.html.haml" do
  let(:announcements) { Announcement.page 1 }
  let(:rss_url) { announcements_url(:rss) }

  before do
    view.stub :admin? => false
    assign :announcements, announcements
  end

  it "should show the rss image" do
    render
    rendered.should have_selector("img[src='/assets/rss.gif']")
  end

  it "should awlays show the rss link" do
    render
    rendered.should have_selector("a[href='#{rss_url}']")
  end

end
