class Notification < ActiveRecord::Base
  belongs_to :user
  belongs_to :source, polymorphic: true

  def is_read_by?(user)
    Notification.has_read_notification(id, user.id).first['count'].to_i > 0
  end

  # attr_protected :full_name, :faculty_number, :email, :admin

  # validates :password, confirmation: true, unless: -> { password.blank? }

  class << self
    def unread_for_user(id)
      t = Notification.arel_table

      Notification.where(
        t[:user_id].eq(id).
        or(t[:user_id].eq(nil))
      ).where('id NOT IN (SELECT notification_id FROM read_notifications WHERE user_id = ?)', id)
    end

    def has_read_notification(notification_id, user_id)
      self.connection.execute(sanitize_sql_array(["SELECT count(*) FROM read_notifications WHERE user_id = ? AND notification_id = ?", user_id, notification_id]))
    end

    def mark_read(notification_id, user_id)
      self.connection.execute(sanitize_sql_array(["INSERT INTO read_notifications (user_id, notification_id) VALUES (?, ?)", user_id, notification_id]))
    end
  end
end
