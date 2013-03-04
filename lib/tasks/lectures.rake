namespace :lectures do
  desc "Generates the lectures form config and copies them to public/lectures"
  task :compile => :environment do
    ENV['REPOSITORY'] = Rails.application.config.lectures_repository
    ENV['BRANCH']     = Rails.application.config.lectures_branch

    exec 'script/lectures'
  end
end
