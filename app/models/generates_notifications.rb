module GeneratesNotifications
  extend self

  def generate_notifications_for(users, title:)
    users.find_each do |user|
      notification = Notification.new
      notification.title = title
      notification.source = self
      notification.user = user
      notification.save!
    end
  end
end