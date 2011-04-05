class StarsController < ApplicationController
  before_filter :require_admin

  def create
    post = Post.find params[:post_id]
    post.star
    redirect_to post_path(post.id)
  end
end
