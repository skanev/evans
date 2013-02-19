class Tip < ActiveRecord::Base
  class << self
    def default_new_pushlied_at
      order("published_at").last.published_at + 1.day rescue Date.today
    end

    def in_reverse_chronological_order
      order('published_at DESC')
    end
  end
end
