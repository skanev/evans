class CreateReadNotifications < ActiveRecord::Migration
  extend ForeignKeys

  def self.up
    create_table :read_notifications do |t|
      t.references  :notification, :null => false
      t.references  :user,  :null => false
    end

    foreign_key :read_notifications, :notification_id
    foreign_key :read_notifications, :user_id
  end

  def self.down
    drop_table :read_notifications
  end
end
