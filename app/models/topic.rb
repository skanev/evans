class Topic < Post
  belongs_to :user
  has_many :replies, :order => 'created_at ASC'

  validates_presence_of :title, :body, :user

  attr_accessible :title, :body

  def replies_on_page(page)
    replies.paginate :page => page, :per_page => Reply.per_page
  end

  def can_be_edited_by?(user)
    user.present? and (user == self.user or user.admin?)
  end

  def pages_of_replies
    if replies.count == 0
      1
    else
      (replies.count - 1) / Reply.per_page + 1
    end
  end

  def last_reply_id
    replies.last.id
  end

  class << self
    def page(page)
      Post.topic_page(page)
    end
  end
end
