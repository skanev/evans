class Comment < ActiveRecord::Base
  validates_presence_of :body

  belongs_to :user
  belongs_to :revision

  attr_protected :user_id, :solution_id

  delegate :solution, to: :revision
  delegate :task, :task_name, to: :solution

  def editable_by?(user)
    self.user == user or user.try(:admin?)
  end

  def user_name
    user.name
  end
end
