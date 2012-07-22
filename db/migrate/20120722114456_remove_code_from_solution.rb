class RemoveCodeFromSolution < ActiveRecord::Migration
  def change
    remove_column :solutions, :code
  end
end
