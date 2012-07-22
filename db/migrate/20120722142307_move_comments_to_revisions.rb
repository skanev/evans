class MoveCommentsToRevisions < ActiveRecord::Migration
  include ForeignKeys

  def up
    add_column :comments, :revision_id, :integer
    foreign_key :comments, :revision_id

    execute <<-SQL
      UPDATE comments
      SET revision_id = revisions.id
      FROM revisions
      WHERE revisions.solution_id = comments.solution_id
    SQL

    change_column :comments, :revision_id, :integer, null: false
    remove_column :comments, :solution_id
  end
end
