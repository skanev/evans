class AddLogToSolution < ActiveRecord::Migration
  def self.up
    add_column :solutions, :log, :text
  end

  def self.down
    remove_column :solutions, :log
  end
end
