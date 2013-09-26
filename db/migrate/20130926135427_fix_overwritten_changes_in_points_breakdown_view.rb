class FixOverwrittenChangesInPointsBreakdownView < ActiveRecord::Migration
  def up
    execute PointsBreakdownView.drop_sql
    execute PointsBreakdownView.create_sql
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
