class CreateQuizResults < ActiveRecord::Migration
  extend ForeignKeys

  def self.up
    create_table :quiz_results do |t|
      t.references  :quiz,              :null => false
      t.references  :user,              :null => false
      t.integer     :correct_answers,   :null => false
      t.integer     :points,            :null => false
      t.timestamps
    end

    foreign_key :quiz_results, :quiz_id
    foreign_key :quiz_results, :user_id
  end

  def self.down
    drop_table :quiz_results
  end
end
