class Announcement < ActiveRecord::Base
  self.per_page = 10

  validates_presence_of :title
  validates_presence_of :body

  class << self
    def page(number)
      order('created_at DESC').paginate :page => number, :per_page => per_page
    end
  end
end
