class AddRestrictionsToTask < ActiveRecord::Migration
  def change
    add_column :tasks, :restrictions, :text, null: false, default: {}.to_yaml
  end
end
