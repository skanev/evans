class Challenge < ActiveRecord::Base
  def closed?
    closes_at.past?
  end
end
