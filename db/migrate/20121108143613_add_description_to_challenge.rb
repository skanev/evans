class AddDescriptionToChallenge < ActiveRecord::Migration
  def change
    change_table :challenges do |t|
      t.text :description, null: false
    end
  end
end
