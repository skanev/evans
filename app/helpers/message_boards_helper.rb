module MessageBoardsHelper
  def edit_post_path(post)
    case post
      when Topic then edit_topic_path(post)
      when Reply then edit_topic_reply_path(post.topic, post)
      else raise "Argument is not a post: #{post.class}"
    end
  end

  def toggle_post_star_link(post)
    render 'topics/toggle_post_star', post: post
  end
end
