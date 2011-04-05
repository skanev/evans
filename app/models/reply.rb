class Reply < Post
  belongs_to :topic

  validates_presence_of :topic_id

  attr_accessible :body

  def can_be_edited_by?(user)
    user.present? and (user == self.user or user.admin?)
  end

  def page_in_topic
    replies_before_this = topic.replies.where('id < ?', id).count
    replies_before_this / Reply.per_page + 1
  end
end
