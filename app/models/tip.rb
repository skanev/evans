class Tip < ActiveRecord::Base
  class << self
    def current
      published.last
    end

    def published
      where('published_at < :now', now: Time.now)
    end

    def default_new_published_at
      last.published_at + 1.day rescue Time.now
    end

    def in_reverse_chronological_order
      order('published_at DESC')
    end

    def published_in_reverse_chronological_order
      published.in_reverse_chronological_order
    end
  end
end
