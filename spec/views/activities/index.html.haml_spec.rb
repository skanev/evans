require 'spec_helper'

describe "activities/index.html.haml" do

  describe "show RSS feed" do
    let(:feed) { Feed.new }

    before do
      view.stub :each_activity => []
      assign :feed, feed
    end

    it_behaves_like "has RSS feed" do
      let(:rss_url) { activities_url(:rss) }
    end
  end

end
