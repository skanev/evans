class AddPointsToChallenges < ActiveRecord::Migration
  def change
    add_column :challenges, :points, :integer, null: false, default: 1
  end
end
