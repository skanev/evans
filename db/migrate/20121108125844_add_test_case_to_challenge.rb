class AddTestCaseToChallenge < ActiveRecord::Migration
  def change
    add_column :challenges, :test_case, :text
  end
end
