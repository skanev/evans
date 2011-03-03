class AddPersonalInformationToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :twitter, :string
    add_column :users, :github, :string
    add_column :users, :skype, :string
    add_column :users, :phone, :string
    add_column :users, :site, :string
    add_column :users, :about, :text
  end

  def self.down
    remove_column :users, :about
    remove_column :users, :site
    remove_column :users, :phone
    remove_column :users, :skype
    remove_column :users, :github
    remove_column :users, :twitter
  end
end
