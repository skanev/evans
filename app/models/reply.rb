class Reply < ActiveRecord::Base
  belongs_to :topic, :counter_cache => true
  belongs_to :user

  validates_presence_of :body, :user_id, :topic_id

  after_create :update_topic_last_poster

  attr_accessible :body

  after_save :reflect_in_posts

  def can_be_edited_by?(user)
    user.present? and (user == self.user or user.admin?)
  end

  def page_in_topic
    replies_before_this = topic.replies.where('id < ?', id).count
    replies_before_this / Reply.per_page + 1
  end

  private

  def update_topic_last_poster
    topic.last_poster_id = user_id
    topic.last_post_at = created_at
    topic.save!
  end

  def reflect_in_posts
    post_id = 100_000 + id
    post = Post.find_by_id(post_id) || Post.new.tap { |p| p.id = post_id }
    post.attributes = attributes.slice(*Post::REPLY_ATTRIBUTES)
    post.type = 'Post'
    post.save!
  end
end
