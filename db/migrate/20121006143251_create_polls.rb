class CreatePolls < ActiveRecord::Migration
  def change
    create_table :polls do |t|
      t.string :name, null: false
      t.text   :blueprint_yaml, null: false

      t.timestamps
    end
  end
end
