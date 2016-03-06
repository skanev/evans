class AddLineNumberToComments < ActiveRecord::Migration
  def change
    change_table :comments do |t|
      t.integer :line_number
    end
  end
end
