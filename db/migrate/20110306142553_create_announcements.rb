class CreateAnnouncements < ActiveRecord::Migration
  def self.up
    create_table :announcements do |t|
      t.string  :title, :null => false
      t.text    :body,  :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :announcements
  end
end
