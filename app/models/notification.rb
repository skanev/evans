class Notification < ActiveRecord::Base
  belongs_to :user
  belongs_to :source, polymorphic: true

  class << self
    def unread_for_user(id)
      where(user_id: id, is_read: false)
    end

    def mark_as_read(notification)
      notification.is_read = true
      notification.save!
    end
  end
end
