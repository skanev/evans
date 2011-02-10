class CreateSignUps < ActiveRecord::Migration
  def self.up
    create_table :sign_ups do |t|
      t.string :full_name,      :null => false
      t.string :faculty_number, :null => false
      t.string :email
      t.string :token

      t.timestamps
    end
  end

  def self.down
    drop_table :sign_ups
  end
end
