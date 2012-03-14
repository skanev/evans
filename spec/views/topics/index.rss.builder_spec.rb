# encoding: utf-8

require 'spec_helper'

describe "topics/index.rss.builder" do
  context "topics list is empty" do
    let(:topics) { nil }

    before do
      assign :posts, topics
    end

    it { should_render :template => 'topics/index.rss.builder' }
  end

  context "topics list is NOT empty" do
    let(:topics) do
      1.upto(2).map do |n|
        Factory.stub(:topic, title: "Post #{n}", body: "Body #{n}")
      end
    end

    before do
      assign :posts, topics
      render :template => 'topics/index.rss.builder', :layout => 'layouts/application.rss.builder'
    end

    it ("shows correct title") { rendered.should contain(rss_title("Форуми")) }

    it "lists all topics and their contents" do
      topics.each do |topic|
        rendered.should contain(topic.title)
        rendered.should contain(topic.body)
      end
    end
  end
end
