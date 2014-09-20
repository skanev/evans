class PostsController < ApplicationController
  before_action :require_admin, only: %w(star unstar)

  def show
    post = Post.find params[:id]

    case post
      when Topic then redirect_to topic_path(post)
      when Reply then redirect_to topic_reply_path(post.topic, post)
      else raise "Don't know how to redirect to a post of type #{post.class}"
    end
  end

  def star
    post = Post.find params[:post_id]
    post.star

    respond_to do |wants|
      wants.html { redirect_to post_path(post.id) }
      wants.js { render json: {starred: true} }
    end
  end

  def unstar
    post = Post.find params[:post_id]
    post.unstar

    respond_to do |wants|
      wants.html { redirect_to post_path(post.id) }
      wants.js { render json: {starred: false} }
    end
  end
end
