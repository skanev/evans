namespace :users do
  namespace :photos do
    desc 'Recreates all image versions'
    task recreate: :environment do
      User.all.each do |user|
        user.photo.recreate_versions! if user.photo.present?
      end
    end
  end
end
