class Tip < ActiveRecord::Base
  class << self
    def current
      where('published_at < :now', now: Time.now).last
    end

    def default_new_pushlied_at
      last.published_at + 1.day rescue Time.now
    end

    def in_reverse_chronological_order
      order('published_at DESC')
    end
  end
end
