class AddCheckedToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :checked, :boolean, null: false, default: false
    execute 'UPDATE tasks SET checked = true'
  end
end
