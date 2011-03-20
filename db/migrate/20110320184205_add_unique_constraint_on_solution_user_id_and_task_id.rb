class AddUniqueConstraintOnSolutionUserIdAndTaskId < ActiveRecord::Migration
  def self.up
    add_index :solutions, [:task_id, :user_id], :unique => true
  end

  def self.down
    remove_index :solutions, [:task_id, :user_id]
  end
end
