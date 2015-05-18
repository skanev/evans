class CreateNotifications < ActiveRecord::Migration
  include ForeignKeys
  
  def self.up
    create_table(:notifications) do |t|
      t.string  :title, :null => false

      # links to object that caused the notification
      t.integer :source_id
      t.string  :source_type

      t.references  :user,      null: true

      t.timestamps
    end

    foreign_key :notifications, :user_id
  end

  def self.down
    drop_table :notifications
  end
end
