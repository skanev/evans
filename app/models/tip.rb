class Tip < ActiveRecord::Base
  class << self
    def current
      published.last
    end

    def published
      where('published_at < :now', now: Time.now)
    end

    def default_new_pushlied_at
      last.published_at + 1.day rescue Time.now
    end

    def in_reverse_chronological_order
      order('published_at DESC')
    end
  end
end
