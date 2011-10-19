class CreateComments < ActiveRecord::Migration
  include ForeignKeys

  def change
    create_table :comments do |t|
      t.references  :solution,  null: false
      t.references  :user,      null: false
      t.text        :body,      null: false

      t.timestamps
    end

    foreign_key :comments, :solution_id
    foreign_key :comments, :user_id

    add_index :comments, :solution_id
  end
end
