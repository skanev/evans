class Post < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :body, :user_id

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
