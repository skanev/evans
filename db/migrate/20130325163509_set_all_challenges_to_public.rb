class SetAllChallengesToPublic < ActiveRecord::Migration
  def change
    execute 'UPDATE challenges SET hidden = FALSE'
  end
end
