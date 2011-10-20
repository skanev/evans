class Comment < ActiveRecord::Base
  validates_presence_of :body

  belongs_to :solution
  belongs_to :user

  attr_protected :user_id, :solution_id

  def editable_by?(user)
    self.user == user or user.try(:admin?)
  end
end
