require 'spec_helper'
require 'uri'

describe "lectures/index.html.haml" do

  describe "show RSS feed" do

    it_behaves_like "has RSS feed" do
      let(:rss_url) { lectures_url(:rss) }
    end
  end

end
