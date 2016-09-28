module FileCache
  class CannotLoadFileError < StandardError
  end

  extend self

  def load(path_or_url)
    Rails.cache.fetch "file_cache:#{path_or_url}", expires_in: 1.hour do
      if path_or_url.to_s.start_with? 'http'
        load_from_url(path_or_url)
      else
        File.read(path_or_url)
      end
    end
  end

  private

  def load_from_url(url)
    response = HTTP.get(url)

    raise CannotLoadFileError.new unless response.status.success?

    response.to_s
  end
end
