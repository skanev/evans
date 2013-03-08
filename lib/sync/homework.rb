module Sync
  module Homework
    extend self

    REPOSITORY_DIR = Rails.root.join('tmp/homework-repo').to_s

    def sync_hidden_repo
      within_repository_dir do
        sync_records 'tasks', Task
        sync_records 'challenges', Challenge
      end
    end

    def merge_public_repo
      within_repository_dir do
        system 'rake public:fetch'
        system 'rake push'
      end
    end

    private

    def within_repository_dir
      clone_repository unless File.exist? REPOSITORY_DIR

      Dir.chdir(REPOSITORY_DIR) do
        pull_repository
        yield
      end
    end

    def clone_repository
      system "git clone --recursive #{Rails.application.config.homework_repository} #{REPOSITORY_DIR}"
      Dir.chdir(REPOSITORY_DIR) do
        system "git checkout #{Rails.application.config.homework_branch}"
      end
    end

    def pull_repository
      system 'git pull'
    end

    def sync_records(dir, model)
      Dir.chdir(dir) do
        Dir['*'].each do |model_id|
          sync_record model_id, model
        end
      end
    end

    def sync_record(model_id, model)
      record    = find_or_build model_id, model
      timestamp = file_modification_date model_id

      return if record.updated_at and record.updated_at >= timestamp

      puts "Need to update #{model.name} with id: #{model_id}"

      attributes = read_attributes model_id

      record.attributes = attributes
      record.updated_at = timestamp
      record.save!
    end

    def find_or_build(id, model)
      if model.exists? id: id
        model.find id
      else
        model.new do |record|
          # TODO Use a better closing time
          record.id = id
          record.closes_at = 6.days.from_now
        end
      end
    end

    def file_modification_date(id)
      [test_file(id), description_file(id)].compact.map(&:mtime).max
    end

    def read_attributes(id)
      name, description = description_file(id).read.split(/\n+/, 2)
      name              = name.gsub(/^#\s+/, '')
      test_case         = test_file(id).try(:read)

      {name: name, description: description, test_case: test_case}
    end

    def description_file(id)
      File.new("#{id}/README.markdown")
    end

    def test_file(id)
      filename = Dir["#{id}/test*"].first
      filename and File.new(filename)
    end
  end
end
