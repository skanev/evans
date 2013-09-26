class AddManuallyScoredToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :manually_scored, :boolean, null: false, default: false
  end
end
