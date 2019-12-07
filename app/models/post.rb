class Post < ActiveRecord::Base
  include Starrable

  belongs_to :user

  validates :body, :user_id, presence: true

  def editable_by?(user)
    user.present? and (user == self.user or user.admin?)
  end
end
