class AddChallengeAndTaskNotificationsToUser < ActiveRecord::Migration
  def change
    add_column :users, :challenge_notification, :boolean, default: true, null: false
    add_column :users, :task_notification,      :boolean, default: true, null: false
  end
end
