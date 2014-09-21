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

  describe "stars" do
    log_in_as :admin

    describe "POST create" do
      let(:a_post) { mock_model(Post) }

      before do
        Post.stub find: a_post
        a_post.stub :star
      end

      it "denies access to non-admins" do
        current_user.stub admin?: false
        post :star, id: '42'
        response.should deny_access
      end

      it "looks up the post by id" do
        Post.should_receive(:find).with('42')
        post :star, id: '42'
      end

      it "stars the post" do
        a_post.should_receive(:star)
        post :star, id: '42'
      end

      it "redirects to the post" do
        post :star, id: '42'
        response.should redirect_to(post_path(a_post))
      end
    end

    describe "DELETE destroy" do
      let(:a_post) { mock_model(Post) }

      before do
        Post.stub find: a_post
        a_post.stub :unstar
      end

      it "denies access to non-admins" do
        current_user.stub admin?: false
        delete :unstar, id: '42'
        response.should deny_access
      end

      it "looks up the post by id" do
        Post.should_receive(:find).with('42')
        delete :unstar, id: '42'
      end

      it "unstars the post" do
        a_post.should_receive(:unstar)
        delete :unstar, id: '42'
      end

      it "redirects to the post" do
        delete :unstar, id: '42'
        response.should redirect_to(post_path(a_post))
      end
    end
  end
end
