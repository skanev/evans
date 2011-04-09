module MessageBoardsHelper
  def edit_post_path(post)
    case post
      when Topic then edit_topic_path(post)
      when Reply then edit_topic_reply_path(post.topic, post)
      else raise "Argument is not a post: #{post.class}"
    end
  end

  def toggle_post_star_link(post)
    if post.starred?
      link_to 'Махни звездичката', post_star_path(post), :method => :delete
    else
      link_to 'Дай звездичка', post_star_path(post), :method => :post
    end
  end
end
