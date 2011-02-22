class AddPhotoToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :photo, :string
  end

  def self.down
    remove_column :users, :photo
  end
end
