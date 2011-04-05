class Post < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :body, :user_id

  def star
    self.starred = true
    save!
  end
end
