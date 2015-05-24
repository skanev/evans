class Notification < ActiveRecord::Base
  belongs_to :user
  belongs_to :source, polymorphic: true

  def mark_as_read
    self.is_read = true
    save!
  end

  class << self
    def unread_for_user(user)
      where(user_id: user.id, is_read: false)
    end

    def send_notifications_for(source, to:, title:)
      to.find_each do |user|
        notification = Notification.new
        notification.title = title
        notification.source = source
        notification.user = user
        notification.save!
      end
    end
  end
end
