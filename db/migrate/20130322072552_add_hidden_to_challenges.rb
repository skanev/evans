class AddHiddenToChallenges < ActiveRecord::Migration
  def change
    add_column :challenges, :hidden, :boolean, default: true, null: false
  end
end
