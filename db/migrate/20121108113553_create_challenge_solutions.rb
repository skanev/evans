class CreateChallengeSolutions < ActiveRecord::Migration
  def change
    create_table :challenge_solutions do |t|
      t.references :user, null: false
      t.references :challenge, null: false
      t.text :code, null: false
      t.timestamps
    end

    add_index :challenge_solutions, [:user_id, :challenge_id], unique: true
  end
end
