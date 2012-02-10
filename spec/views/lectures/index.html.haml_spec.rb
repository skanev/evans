require 'spec_helper'
require 'uri'

describe "lectures/index.html.haml" do
  let(:rss_url) { lectures_url(:rss) }

  it "should show the rss image" do
    render
    rendered.should have_selector("img[src='#{rss_image_path}']")
  end

  it "should show the rss link" do
    render
    rendered.should have_selector("a[href='#{rss_url}']")
  end

    it "should open a view with xml content when click on rss link"

    it "rss page should have the correct content"
end
