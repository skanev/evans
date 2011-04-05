class PostsController < ApplicationController
  def show
    post = Post.find params[:id]

    case post
      when Topic then redirect_to topic_path(post)
      when Reply then redirect_to topic_reply_path(post.topic, post)
      else raise "Don't know how to redirect to a post of type #{post.class}"
    end
  end
end
