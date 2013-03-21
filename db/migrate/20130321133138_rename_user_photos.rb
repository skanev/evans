class RenameUserPhotos < ActiveRecord::Migration
  def up
    execute <<-SQL
      UPDATE users
      SET photo = 'photo.jpg'
      WHERE photo IS NOT NULL AND
            photo != ''
    SQL
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
