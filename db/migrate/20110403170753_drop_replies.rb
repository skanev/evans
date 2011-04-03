class DropReplies < ActiveRecord::Migration
  def self.up
    drop_table :replies
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
