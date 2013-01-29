class CreateTips < ActiveRecord::Migration
  def change
    create_table :tips do |t|
      t.string :title, null: false
      t.text :body, null: false
      t.datetime :published_at, null: false

      t.timestamps
    end
  end
end
