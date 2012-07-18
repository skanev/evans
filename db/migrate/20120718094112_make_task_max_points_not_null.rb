class MakeTaskMaxPointsNotNull < ActiveRecord::Migration
  def up
    change_column :tasks, :max_points, :integer, null: false, default: 6
  end

  def down
    change_column :tasks, :max_points, :integer, null: true, default: nil
  end
end
