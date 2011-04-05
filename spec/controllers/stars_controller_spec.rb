require 'spec_helper'

describe StarsController do
  describe "POST create" do
    let(:a_post) { mock_model(Post) }

    before do
      Post.stub :find => a_post
      a_post.stub :star
    end

    it "looks up the post by id" do
      Post.should_receive(:find).with(42)
      post :create, :post_id => 42
    end

    it "stars the post" do
      a_post.should_receive(:star)
      post :create, :post_id => 42
    end

    it "redirects to the post" do
      post :create, :post_id => 42
      response.should redirect_to(post_path(a_post))
    end
  end
end
