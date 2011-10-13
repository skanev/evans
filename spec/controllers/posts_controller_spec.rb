require 'spec_helper'

describe PostsController do
  describe "GET show" do
    it "redirects to TopicsController if the post is a topic" do
      topic = Factory.stub :topic
      Post.should_receive(:find).with('42').and_return(topic)
      get :show, :id => '42'
      response.should redirect_to(topic_path(topic))
    end

    it "redirects to RepliesController if the post is a reply" do
      topic = Factory.stub :topic
      reply = Factory.stub(:reply, :topic => topic)
      Post.should_receive(:find).with('42').and_return(reply)
      get :show, :id => '42'
      response.should redirect_to(topic_reply_path(topic, reply))
    end
  end
end
