require 'rubygems/package'

module TarGzipWriter
  def self.wrap(io)
    Zlib::GzipWriter.wrap(io) do |gzip|
      Gem::Package::TarWriter.new(gzip) do |tar|
        yield tar
      end
    end
  end
end
