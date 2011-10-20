class AddCommentNotificationToUser < ActiveRecord::Migration
  def change
    add_column :users, :comment_notification, :boolean, default: true, null: false
  end
end
