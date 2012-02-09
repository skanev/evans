require 'spec_helper'
require 'uri'

describe "lectures/index.html.haml" do
  let(:rss_url) { lectures_url(:rss) }

#   before do
#     assign :lectures, lectures
#   end

  it "should show the rss image" do
    render
    rendered.should have_selector("img[src='#{rss_image_path}']")
  end

  it "should show the rss link" do
    render
    rendered.should have_selector("a[href='#{rss_url}']")
  end

end
