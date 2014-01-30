class Reply < Post
  belongs_to :topic

  validates_presence_of :topic_id

  attr_accessible :body

  def topic_title
    topic.title
  end

  def page_in_topic
    replies_before_this = topic.replies.where('id < ?', id).count
    replies_before_this / Reply.per_page + 1
  end

  def body_preview(limit)
    if body.length <= limit
      body
    else
      "#{body[0...limit]}..."
    end
  end
end
