class Reply < Post
  belongs_to :topic
  belongs_to :user

  attr_accessible :body

  validates :topic_id, presence: true

  after_create :post_notification

  def topic_title
    topic.title
  end

  def page_in_topic
    replies_before_this = topic.replies.where('id < ?', id).count
    replies_before_this / Reply.per_page + 1
  end

  private

  def post_notification
    topic.users.each do |user|
      notification = Notification.new
      notification.title = "Новo отговор в тема: #{topic_title}"
      notification.source = topic
      notification.user = user
      notification.save
    end
  end
end
