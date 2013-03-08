namespace :sync do
  namespace :homework do
    desc 'Updates the site with the data in the hidden homework repository'
    task hidden: :environment do
      Sync::Homework.sync_hidden_repo
    end

    desc 'Merges changes from the public repo into the private one'
    task public: :environment do
      Sync::Homework.merge_public_repo
    end
  end
end
