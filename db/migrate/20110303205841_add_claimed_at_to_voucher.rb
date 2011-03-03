class AddClaimedAtToVoucher < ActiveRecord::Migration
  def self.up
    add_column :vouchers, :claimed_at, :timestamp
  end

  def self.down
    remove_column :vouchers, :claimed_at
  end
end
