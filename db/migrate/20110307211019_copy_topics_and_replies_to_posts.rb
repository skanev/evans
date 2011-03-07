class CopyTopicsAndRepliesToPosts < ActiveRecord::Migration
  def self.up
    execute <<-SQL
      INSERT INTO posts (id, user_id, title, body, type, created_at, updated_at)
        SELECT id, user_id, title, body, 'Topic', created_at, updated_at FROM topics;
    SQL

    max_id = execute('SELECT MAX(id) AS next FROM posts')[0]['next'].to_i

    execute <<-SQL
      ALTER SEQUENCE posts_id_seq RESTART WITH #{max_id + 1};

      INSERT INTO posts (user_id, topic_id, body, type, created_at, updated_at)
        SELECT user_id, topic_id, body, 'Reply', created_at, updated_at FROM replies;
    SQL
  end

  def self.down
    execute "TRUNCATE TABLE posts RESTART IDENTITY"
  end
end
