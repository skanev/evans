class CreatePollAnswers < ActiveRecord::Migration
  def change
    create_table :poll_answers do |t|
      t.references :poll, null: false
      t.references :user, null: false
      t.text       :answers_yaml, null: false

      t.timestamps
    end

    add_index :poll_answers, :poll_id
    add_index :poll_answers, :user_id
  end
end
