class Challenge < ActiveRecord::Base
  has_many :solutions, -> { order 'created_at ASC' }, class_name: 'ChallengeSolution'

  validates :name, :description, presence: true

  class << self
    def in_chronological_order
      order('created_at ASC')
    end

    def visible
      where(hidden: false).in_chronological_order
    end

    def find_with_solutions_and_users(challenge_id)
      includes(solutions: :user).find(challenge_id)
    end
  end

  def closed?
    closes_at.past?
  end
end
