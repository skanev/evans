class AddUserIdToTips < ActiveRecord::Migration
  extend ForeignKeys

  def self.up
    add_column :tips, :user_id, :integer, :null => false

    foreign_key :tips, :user_id
  end

  def self.down
    remove_column :tips, :user_id
  end
end
