class Topic < ActiveRecord::Base
  belongs_to :user
  belongs_to :last_poster, :class_name => 'User'
  has_many :replies, :order => 'created_at ASC'

  validates_presence_of :title, :body, :user

  before_create :update_last_post

  attr_accessible :title, :body

  def replies_on_page(page)
    replies.paginate :page => page, :per_page => Reply.per_page
  end

  def can_be_edited_by?(user)
    user.present? and (user == self.user or user.admin?)
  end

  def pages_of_replies
    if replies_count == 0
      1
    else
      (replies_count - 1) / Reply.per_page + 1
    end
  end

  def last_reply_id
    replies.last.id
  end

  class << self
    def page(page)
      paginate(:page => page, :order => 'last_post_at DESC')
    end
  end

  private

  def update_last_post
    self.last_poster_id ||= user_id
    self.last_post_at ||= Time.now
  end
end
