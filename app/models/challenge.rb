class Challenge < ActiveRecord::Base
  has_many :solutions, class_name: 'ChallengeSolution'

  def closed?
    closes_at.past?
  end
end
