class AddTestCaseToTasks < ActiveRecord::Migration
  def self.up
    add_column :tasks, :test_case, :text
  end

  def self.down
    remove_column :tasks, :test_case
  end
end
