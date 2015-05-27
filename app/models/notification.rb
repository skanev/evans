class Notification < ActiveRecord::Base
  belongs_to :user
  belongs_to :source, polymorphic: true

  def mark_as_read
    self.read = true
    save!
  end

  class << self
    def unread_for_user(user)
      where(user_id: user.id, read: false)
    end

    def create_notifications_for(source, to: [], title: nil)
      to.find_each do |user|
        Notification.create do |notification|
          notification.title = title
          notification.source = source
          notification.user = user
        end
      end
    end
  end
end
