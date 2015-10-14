class AddReviewerToSolutions < ActiveRecord::Migration
  include ForeignKeys

  def change
    add_reference :solutions, :reviewer, references: :users, index: true
    foreign_key :solutions, :reviewer_id, :users
  end
end
