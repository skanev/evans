class CreateTopics < ActiveRecord::Migration
  extend ForeignKeys

  def self.up
    create_table :topics do |t|
      t.references  :user,    :null => false
      t.string      :title,   :null => false
      t.text        :body,    :null => false

      t.timestamps
    end

    foreign_key :topics, :user_id
  end

  def self.down
    drop_table :topics
  end
end
