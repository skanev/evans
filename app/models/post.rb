class Post < ActiveRecord::Base
  belongs_to :user

  validates :body, :user_id, presence: true

  def editable_by?(user)
    user.present? and (user == self.user or user.admin?)
  end

  def star
    update_column(:starred, true)
  end

  def unstar
    update_column(:starred, false)
  end
end
