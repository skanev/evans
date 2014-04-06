class Post < ActiveRecord::Base
  belongs_to :user

  validates :body, :user_id, presence: true

  def editable_by?(user)
    user.present? and (user == self.user or user.admin?)
  end

  def star
    self.starred = true
    save!
  end

  def unstar
    self.starred = false
    save!
  end
end
