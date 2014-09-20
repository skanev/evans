class AddStarredToComments < ActiveRecord::Migration
  def change
    add_column :comments, :starred, :boolean, default: false, null: false
  end
end
