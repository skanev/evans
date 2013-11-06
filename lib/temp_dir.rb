module TempDir
  extend self

  def for(files)
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
