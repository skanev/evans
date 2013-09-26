class AddLinkToAttributions < ActiveRecord::Migration
  def change
    add_column :attributions, :link, :string, null: false
  end
end
