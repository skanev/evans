class AddPointsToSolutions < ActiveRecord::Migration
  def change
    add_column :solutions, :points, :integer, null: false, default: 0
  end
end
