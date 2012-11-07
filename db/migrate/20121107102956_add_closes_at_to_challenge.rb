class AddClosesAtToChallenge < ActiveRecord::Migration
  def change
    add_column :challenges, :closes_at, :timestamp, null: false
  end
end
