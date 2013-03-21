class AddCheckedToChallenge < ActiveRecord::Migration
  def change
    add_column :challenges, :checked, :boolean, null: false, default: false
  end
end
