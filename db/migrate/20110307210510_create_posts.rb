class CreatePosts < ActiveRecord::Migration
  extend ForeignKeys

  def self.up
    create_table :posts do |t|
      t.integer     :user_id,    :null => false
      t.string      :title
      t.text        :body,       :null => false
      t.integer     :topic_id
      t.string      :type,       :null => false

      t.timestamps
    end

    foreign_key :posts, :user_id
    foreign_key :posts, :topic_id, :posts
  end

  def self.down
    drop_table :posts
  end
end
