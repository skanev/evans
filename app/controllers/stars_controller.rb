class StarsController < ApplicationController
  before_action :require_admin

  def create
    post = Post.find params[:post_id]
    post.star

    respond_to do |wants|
      wants.html { redirect_to post_path(post.id) }
      wants.js { render json: {starred: true} }
    end
  end

  def destroy
    post = Post.find params[:post_id]
    post.unstar

    respond_to do |wants|
      wants.html { redirect_to post_path(post.id) }
      wants.js { render json: {starred: false} }
    end
  end
end
