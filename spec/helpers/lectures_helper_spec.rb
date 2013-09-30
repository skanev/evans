require 'spec_helper'

describe LecturesHelper do
  describe "#lecture_title" do
    it "can remove the number from the lecture title" do
      helper.lecture_title(title: '01. Lecture').should eq 'Lecture'
    end
  end

  describe "#lecture_url" do
    it "links to a file in public/lectures/ if given a slug" do
      helper.lecture_url(slug: '01-lecture').should eq '/lectures/01-lecture'
    end

    it "links to an URL if given one" do
      helper.lecture_url(url: 'http://example.org/').should eq 'http://example.org/'
    end
  end
end
