#!/usr/bin/env ruby

require 'tmpdir'

code = ARGF.read

exit 0 if code.empty?

if code !~ /^\s*func\s+main\(\s*\)/
  code += "\nfunc main() {\n}\n"
end

build_result = nil

Dir.mktmpdir do |dir|
  FileUtils.cd(dir) do
    File.open('code.go', 'w') do |f|
      f.write(code)
    end

    build_result = `go build code.go 2>&1`
  end
end

if build_result.strip.empty?
  exit 0
else
  exit 1
end
