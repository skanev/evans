class DropTopics < ActiveRecord::Migration
  def self.up
    drop_table :topics
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
