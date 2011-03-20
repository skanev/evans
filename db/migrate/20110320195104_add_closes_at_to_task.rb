class AddClosesAtToTask < ActiveRecord::Migration
  def self.up
    add_column :tasks, :closes_at, :datetime, :null => false
  end

  def self.down
    remove_column :tasks, :closes_at
  end
end
