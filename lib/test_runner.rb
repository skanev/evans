module TestRunner
  extend self

  class Results
    attr_accessor :passed, :failed, :log

    def initialize(attributes = {})
      attributes.each do |key, value|
        send "#{key}=", value
      end
    end

    def passed_count
      passed.count
    end

    def failed_count
      failed.count
    end
  end

  def with_tmpdir(files)
    Dir.mktmpdir do |dir|
      dir_path = Pathname(dir)

      files.each do |name, contents|
        file_path = dir_path.join(name)
        open(file_path, 'w') { |file| file.write contents.encode('utf-8') }
      end

      yield dir_path
    end
  end
end
