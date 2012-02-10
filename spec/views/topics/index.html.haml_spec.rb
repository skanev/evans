require 'spec_helper'
require 'uri'

describe "topics/index.html.haml" do
  let(:topics) { Topic.page 1 }
  let(:rss_url) { topics_url(:rss) }

  before do
    assign :topics, topics
  end

  context 'when a user is not logged in' do
    before do
      view.stub :logged_in? => false
    end

    it "should not show the rss image" do
      render
      rendered.should_not have_selector("img[src='#{rss_image_path}']")
    end

    it "should not show the rss link" do
      render
      rendered.should_not have_selector("a[href='#{rss_url}']")
    end

    it "should open a view with xml content when click on rss link"

    it "rss page should have the correct content"
  end

  context 'when a user is logged in' do
    before do
      view.stub :logged_in? => true
    end

    it "should show the rss image" do
      render
      rendered.should have_selector("img[src='#{rss_image_path}']")
    end

    it "should show the rss link" do
      render
      rendered.should have_selector("a[href='#{rss_url}']")
    end
  end

end
