class CreateSolutions < ActiveRecord::Migration
  extend ForeignKeys

  def self.up
    create_table :solutions do |t|
      t.references :user, :null => false
      t.references :task, :null => false
      t.text       :code, :null => false

      t.timestamps
    end

    foreign_key :solutions, :task_id
    foreign_key :solutions, :user_id
  end

  def self.down
    drop_table :solutions
  end
end
