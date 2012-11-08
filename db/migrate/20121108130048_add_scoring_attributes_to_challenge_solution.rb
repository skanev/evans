class AddScoringAttributesToChallengeSolution < ActiveRecord::Migration
  def change
    change_table :challenge_solutions do |t|
      t.integer :passed_tests, null: false, default: 0
      t.integer :failed_tests, null: false, default: 0
      t.text :log
      t.boolean :correct, null: false, default: false
    end
  end
end
