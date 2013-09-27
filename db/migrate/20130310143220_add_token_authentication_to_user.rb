class AddTokenAuthenticationToUser < ActiveRecord::Migration
  class User < ActiveRecord::Base
    devise :token_authenticatable
  end

  def change
    add_column :users, :authentication_token, :string
    ensure_users_have_authentication_tokens
  end

  private

  def ensure_users_have_authentication_tokens
    User.all.each(&:ensure_authentication_token!)
  end
end
