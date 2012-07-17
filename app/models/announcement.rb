class Announcement < ActiveRecord::Base
  self.per_page = 10

  validates_presence_of :title
  validates_presence_of :body

  class << self
    def reverse_chronological
      order('created_at DESC')
    end

    def page(number)
      reverse_chronological.paginate page: number, per_page: per_page
    end

    def latest(number)
      reverse_chronological.limit(number)
    end
  end
end
