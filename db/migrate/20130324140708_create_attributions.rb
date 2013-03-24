class CreateAttributions < ActiveRecord::Migration
  include ForeignKeys

  def change
    create_table :attributions do |t|
      t.string :reason, null: false
      t.integer :user_id

      t.timestamps
    end

    foreign_key :attributions, :user_id
  end
end
