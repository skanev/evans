class CreateRevisions < ActiveRecord::Migration
  include ForeignKeys

  def change
    create_table :revisions do |t|
      t.references :solution, null: false
      t.text :code, null: false
      t.timestamps
    end

    foreign_key :revisions, :solution_id
    add_index :revisions, :solution_id

    execute <<-SQL
      INSERT INTO revisions (solution_id, code, created_at, updated_at)
      SELECT id, code, created_at, created_at FROM solutions
    SQL
  end
end
