class Reply < Post
  belongs_to :topic

  attr_accessible :body

  validates :topic_id, presence: true

  def topic_title
    topic.title
  end

  def page_in_topic
    replies_before_this = topic.replies.where('id < ?', id).count
    replies_before_this / Reply.per_page + 1
  end
end
