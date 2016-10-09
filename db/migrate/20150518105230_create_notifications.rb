class CreateNotifications < ActiveRecord::Migration
  include ForeignKeys
  
  def self.up
    create_table(:notifications) do |t|
      t.string  :title, null: false
      t.references :source, polymorphic: true
      t.boolean :read, default: false
      t.references  :user
      t.timestamps
    end

    foreign_key :notifications, :user_id
  end

  def self.down
    drop_table :notifications
  end
end
