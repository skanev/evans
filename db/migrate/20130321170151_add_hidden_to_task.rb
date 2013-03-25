class AddHiddenToTask < ActiveRecord::Migration
  def change
    add_column :tasks, :hidden, :boolean, null: false, default: true
    execute 'UPDATE tasks SET hidden = FALSE'
  end
end
