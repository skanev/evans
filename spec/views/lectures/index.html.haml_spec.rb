require 'spec_helper'
require 'uri'

describe "lectures/index.html.haml" do

  context "lectures list is not empty" do
    let(:lecture) { { title: "Title", url: "www.example.com", date: Date.today } }

    before do
      assign :lectures, [ lecture ]
    end

    it "should list the lectures" do
      render
      rendered.should contain lecture[:title]
    end
  end

  describe "show RSS feed" do

    it_behaves_like "has RSS feed" do
      let(:rss_url) { lectures_url(:rss) }
    end
  end

end
