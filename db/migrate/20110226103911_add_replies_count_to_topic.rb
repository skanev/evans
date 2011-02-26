class AddRepliesCountToTopic < ActiveRecord::Migration
  def self.up
    add_column :topics, :replies_count, :integer, :null => false, :default => 0
  end

  def self.down
    remove_column :topics, :replies_count
  end
end
