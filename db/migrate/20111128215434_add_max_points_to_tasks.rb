class AddMaxPointsToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :max_points, :integer
  end
end
