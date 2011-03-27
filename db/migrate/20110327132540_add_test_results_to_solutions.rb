class AddTestResultsToSolutions < ActiveRecord::Migration
  def self.up
    add_column :solutions, :passed_tests, :integer, :null => false, :default => 0
    add_column :solutions, :failed_tests, :integer, :null => false, :default => 0
  end

  def self.down
    remove_column :solutions, :failed_tests
    remove_column :solutions, :passed_tests
  end
end
