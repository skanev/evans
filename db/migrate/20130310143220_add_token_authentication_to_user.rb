class  AddTokenAuthenticationToUser < ActiveRecord::Migration
  def change
    add_column :users, :authentication_token , :string
    User.all.each(&:reset_authentication_token)
  end
end
