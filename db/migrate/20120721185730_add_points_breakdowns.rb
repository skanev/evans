class AddPointsBreakdowns < ActiveRecord::Migration
  def up
    execute <<-SQL
      CREATE VIEW points_breakdowns AS
      WITH users_tasks AS (
        SELECT
          users.id AS user_id,
          tasks.id AS task_id,
          GREATEST(COALESCE(points + adjustment, 0), 0) AS points
        FROM users
        INNER JOIN tasks ON TRUE
        LEFT JOIN solutions ON (solutions.task_id = tasks.id AND solutions.user_id = users.id)
        ORDER BY users.id, tasks.id
      ), tasks_summary AS (
        SELECT
          user_id,
          array_agg(points) AS breakdown,
          SUM(points) AS points
        FROM users_tasks
        GROUP BY user_id
      ), users_quizzes AS (
        SELECT
          users.id AS user_id,
          quizzes.id AS quiz_id,
          COALESCE(points, 0) AS points
        FROM users
        INNER JOIN quizzes ON TRUE
        LEFT JOIN quiz_results ON (quiz_results.quiz_id = quizzes.id AND quiz_results.user_id = users.id)
        ORDER BY users.id, quizzes.id
      ), quizzes_summary AS (
        SELECT
          user_id,
          array_agg(points) AS breakdown,
          SUM(points) AS points
        FROM users_quizzes
        GROUP BY user_id
      ), stars_summary AS (
        SELECT
          users.id AS user_id,
          COUNT(posts.starred) AS points
        FROM users
        LEFT JOIN posts ON posts.user_id = users.id AND posts.starred
        GROUP BY users.id
      ), vouchers_summary AS (
        SELECT
          users.id AS user_id,
          COUNT(vouchers.id) AS points
        FROM users
        LEFT JOIN vouchers ON vouchers.user_id = users.id
        GROUP BY users.id
      ), arrays_summary AS (
        SELECT
          users.id AS user_id,
          COALESCE(tasks_summary.breakdown, '{}') AS tasks_breakdown,
          COALESCE(tasks_summary.points, 0) AS tasks,
          COALESCE(quizzes_summary.breakdown, '{}') AS quizzes_breakdown,
          COALESCE(quizzes_summary.points, 0) AS quizzes
        FROM users
        LEFT JOIN tasks_summary ON tasks_summary.user_id = users.id
        LEFT JOIN quizzes_summary ON quizzes_summary.user_id = users.id
      )
      SELECT
        rank() OVER (ORDER BY arrays_summary.tasks + arrays_summary.quizzes + stars_summary.points + vouchers_summary.points DESC) AS rank,
        users.id AS id,
        users.name AS name,
        users.faculty_number AS faculty_number,
        arrays_summary.tasks_breakdown AS tasks_breakdown,
        arrays_summary.tasks AS tasks,
        arrays_summary.quizzes_breakdown AS quizzes_breakdown,
        arrays_summary.quizzes AS quizzes,
        stars_summary.points AS stars,
        vouchers_summary.points AS vouchers,
        arrays_summary.tasks + quizzes_summary.points + stars_summary.points + vouchers_summary.points AS total
      FROM users
      LEFT JOIN arrays_summary ON arrays_summary.user_id = users.id
      LEFT JOIN quizzes_summary ON quizzes_summary.user_id = users.id
      LEFT JOIN stars_summary ON stars_summary.user_id = users.id
      LEFT JOIN vouchers_summary ON vouchers_summary.user_id = users.id
      WHERE NOT users.admin
      ORDER BY rank
    SQL
  end

  def down
    execute 'DROP VIEW points_breakdowns'
  end
end
