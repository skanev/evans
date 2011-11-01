class AddAdjustmentToSolution < ActiveRecord::Migration
  def change
    add_column :solutions, :adjustment, :integer, null: false, default: 0
  end
end
