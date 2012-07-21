class AddNameToUsers < ActiveRecord::Migration
  def change
    add_column :users, :name, :string
    execute %q{UPDATE users SET name = regexp_replace(full_name, '(\\S+)\\s+(\\S+\\s+)*(\\S+)', '\\1 \\3')}
    change_column :users, :name, :string, null: false
  end
end
