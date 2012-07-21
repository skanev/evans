class AddPointsToSolutions < ActiveRecord::Migration
  def change
    add_column :solutions, :points, :integer, null: false, default: 0
    execute <<-SQL
      UPDATE solutions
      SET points = GREATEST(0,
        CASE WHEN (failed_tests + passed_tests = 0)
          THEN 0
          ELSE round(passed_tests::numeric / (failed_tests::numeric + passed_tests::numeric) * tasks.max_points)
        END)
      FROM tasks
      WHERE solutions.task_id = tasks.id
    SQL
  end
end
