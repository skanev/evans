require 'spec_helper'

describe StarsController do
  log_in_as :admin

  describe "POST create" do
    let(:a_post) { mock_model(Post) }

    before do
      Post.stub find: a_post
      a_post.stub :star
    end

    it "denies access to non-admins" do
      current_user.stub admin?: false
      post :create, post_id: '42'
      expect(response).to deny_access
    end

    it "looks up the post by id" do
      expect(Post).to receive(:find).with('42')
      post :create, post_id: '42'
    end

    it "stars the post" do
      expect(a_post).to receive(:star)
      post :create, post_id: '42'
    end

    it "redirects to the post" do
      post :create, post_id: '42'
      expect(response).to redirect_to(post_path(a_post))
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
      delete :destroy, post_id: '42'
      expect(response).to deny_access
    end

    it "looks up the post by id" do
      expect(Post).to receive(:find).with('42')
      delete :destroy, post_id: '42'
    end

    it "unstars the post" do
      expect(a_post).to receive(:unstar)
      delete :destroy, post_id: '42'
    end

    it "redirects to the post" do
      delete :destroy, post_id: '42'
      expect(response).to redirect_to(post_path(a_post))
    end
  end
end
