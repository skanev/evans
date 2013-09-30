require 'spec_helper'

describe PostsController do
  describe "GET show" do
    it "redirects to TopicsController if the post is a topic" do
      topic = build_stubbed :topic
      Post.should_receive(:find).with('42').and_return(topic)
      get :show, id: '42'
      response.should redirect_to(topic_path(topic))
    end

    it "redirects to RepliesController if the post is a reply" do
      topic = build_stubbed :topic
      reply = build_stubbed :reply, topic: topic
      Post.should_receive(:find).with('42').and_return(reply)
      get :show, id: '42'
      response.should redirect_to(topic_reply_path(topic, reply))
    end

    it "raises an error if it matches a non-topic or a non-reply" do
      Post.should_receive(:find).with('42').and_return Object.new
      expect { get :show, id: '42' }.to raise_error
    end
  end
end
