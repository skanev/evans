# encoding: utf-8

require 'spec_helper'

describe "announcements/index.rss.builder" do
  let(:announcements) do
    1.upto(2).map do |n|
      Factory.stub(:announcement, title: "News #{n}", body: "Desc #{n}")
    end
  end

  before do
    assign :announcements, announcements
    render :template => 'announcements/index.rss.builder', :layout => 'layouts/application.rss.builder'
  end

  it ("shows correct title") { rendered.should contain(rss_title("Новини")) }

  it "lists all tasks and their contents" do
    announcements.each do |announcement|
      rendered.should contain(announcement.title)
      rendered.should contain(announcement.body)
    end
  end
end
