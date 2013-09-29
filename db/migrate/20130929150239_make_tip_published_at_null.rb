class MakeTipPublishedAtNull < ActiveRecord::Migration
  def change
    change_table :tips do |t|
      t.change :published_at, :datetime, null: true, default: nil
    end
  end
end
