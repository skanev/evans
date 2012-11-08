class Challenge < ActiveRecord::Base
  has_many :solutions, class_name: 'ChallengeSolution'

  class << self
    def in_reverse_chronological_order
      order('created_at DESC')
    end
  end

  def closed?
    closes_at.past?
  end
end
