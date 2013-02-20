class Tip < ActiveRecord::Base
  class << self
    def current
      order("published_at").last
    end

    def default_new_pushlied_at
      current.published_at + 1.day rescue Date.today
    end

    def in_reverse_chronological_order
      order('published_at DESC')
    end
  end
end
