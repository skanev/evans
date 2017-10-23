#!/usr/bin/env ruby

require 'tmpdir'

code = ARGF.read

exit 0 if code.empty?

build_result = nil

Dir.mktmpdir do |dir|
  FileUtils.cd(dir) do
    FileUtils.mkdir_p('solution/src')

    File.open('solution/src/lib.rs', 'w') do |f|
      f.write(code)
    end

    File.open('solution/Cargo.toml', 'w') do |f|
      f.write(<<~EOF)
        [package]
        name = "solution"
        version = "0.1.0"
        authors = ["Rust Course <fmi@rust-lang.bg>"]

        [dependencies]
      EOF
    end

    build_result = `cd solution && cargo build 2>&1`
  end
end

if build_result =~ /error:|warning:/
  exit 1
else
  exit 0
end
