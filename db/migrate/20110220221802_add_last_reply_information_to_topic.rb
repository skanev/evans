class AddLastReplyInformationToTopic < ActiveRecord::Migration
  extend ForeignKeys

  def self.up
    change_table :topics do |t|
      t.integer     :last_poster_id,  :null => false
      t.timestamp   :last_post_at,    :null => false
    end

    foreign_key :topics, :last_poster_id, :users
  end

  def self.down
    change_table :topics do |t|
      t.remove :last_poster_id
      t.remove :last_post_at
    end
  end
end
