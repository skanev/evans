class PostsController < ApplicationController
  include AwardsContributions

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
    star_contribution post, and_redirect_to: post_path(post.id)
  end

  def unstar
    post = Post.find params[:post_id]
    unstar_contribution post, and_redirect_to: post_path(post.id)
  end
end
