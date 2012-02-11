require 'spec_helper'

describe "topics/index.html.haml" do

  describe "show RSS feed when user is logged" do
    let(:topics) { Topic.page 1 }

    before do
      view.stub :logged_in? => true
      assign :topics, topics
    end

    it_behaves_like "has RSS feed" do
      let(:rss_url) { topics_url(:rss) }
    end
  end

  it "hides RSS feed when user is not logged"

  it "renders RSS template when there are no topics"

end
