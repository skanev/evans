class StarsController < ApplicationController
  def create
    post = Post.find params[:post_id]
    post.star
    redirect_to post
  end
end
