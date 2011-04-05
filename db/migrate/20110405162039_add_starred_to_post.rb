class AddStarredToPost < ActiveRecord::Migration
  def self.up
    add_column :posts, :starred, :boolean, :null => false, :default => false
  end

  def self.down
    remove_column :posts, :starred
  end
end
