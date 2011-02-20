class Topic < ActiveRecord::Base
  belongs_to :user
  has_many :replies, :order => 'created_at ASC'

  validates_presence_of :title, :body, :user

  attr_accessible :title, :body

  def posts_on_page(page)
    posts = replies.paginate :page => page, :per_page => self.class.posts_per_page
    posts.unshift self if page.to_i == 1
    posts
  end

  class << self
    def page(page)
      paginate(:page => page, :order => 'created_at DESC')
    end

    def posts_per_page
      30
    end
  end
end
