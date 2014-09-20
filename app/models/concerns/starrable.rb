module Starrable
  extend ActiveSupport::Concern

  def star
    self.starred = true
    save!
  end

  def unstar
    self.starred = false
    save!
  end
end
