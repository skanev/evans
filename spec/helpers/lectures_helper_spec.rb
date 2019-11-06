require 'spec_helper'

describe LecturesHelper do
  describe "#lecture_title" do
    it "can remove the number from the lecture title" do
      expect(helper.lecture_title(title: '01. Lecture')).to eq 'Lecture'
    end
  end

  describe "#lecture_url" do
    it "links to a file in public/lectures/ if given a slug" do
      expect(helper.lecture_url(slug: '01-lecture')).to eq '/lectures/01-lecture'
    end

    it "links to an URL if given one" do
      expect(helper.lecture_url(url: 'http://example.org/')).to eq 'http://example.org/'
    end
  end
end
