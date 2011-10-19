class Comment < ActiveRecord::Base
  belongs_to :solution
  belongs_to :user

  attr_protected :user_id, :solution_id

  class << self
    def submit(solution, user, attributes)
      create!(attributes) do |comment|
        comment.solution = solution
        comment.user     = user
      end
    end
  end
end
