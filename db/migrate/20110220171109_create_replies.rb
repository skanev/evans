class CreateReplies < ActiveRecord::Migration
  extend ForeignKeys

  def self.up
    create_table :replies do |t|
      t.references  :topic, :null => false
      t.references  :user,  :null => false
      t.text        :body,  :null => false
      t.timestamps
    end

    foreign_key :replies, :topic_id
    foreign_key :replies, :user_id
  end

  def self.down
    drop_table :replies
  end
end
