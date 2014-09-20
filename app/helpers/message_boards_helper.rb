module MessageBoardsHelper
  def edit_post_path(post)
    case post
      when Topic then edit_topic_path(post)
      when Reply then edit_topic_reply_path(post.topic, post)
    end
  end

  def toggle_post_star_link(post)
    render 'common/toggle_contribution_star', star_path: post_star_path(post),
                                              unstar_path: post_unstar_path(post)
  end
end
