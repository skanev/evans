class PointsBreakdown
  def initialize(user)
    @user = user
  end

  def each_starred_post_with_title
    starred_posts.each do |post|
      yield post, post.topic_title
    end

    nil
  end

  def having_starred_posts?
    starred_posts.exists?
  end

  private

  def starred_posts
    Post.where(user_id: @user.id, starred: true)
  end
end
