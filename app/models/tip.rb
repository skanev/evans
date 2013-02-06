class Tip < ActiveRecord::Base
  class << self
    def default_new_pushlied_at
      order("published_at").last.published_at + 1.day rescue Date.today
    end
  end
end
