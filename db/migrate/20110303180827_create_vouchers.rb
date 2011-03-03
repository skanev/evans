class CreateVouchers < ActiveRecord::Migration
  extend ForeignKeys

  def self.up
    create_table :vouchers do |t|
      t.string    :code,        :null => false
      t.integer   :user_id
      t.timestamps
    end

    foreign_key :vouchers, :user_id
    add_index :vouchers, :code, :unique => true
  end

  def self.down
    drop_table :vouchers
  end
end
