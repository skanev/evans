class Reply < Post

  include GeneratesNotifications

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
    generate_notifications_for topic.users, title: "Нов отговор в тема: #{topic_title}"
  end
end
