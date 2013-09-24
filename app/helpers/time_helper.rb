module TimeHelper
  def relative_time_in_words(time)
    prefix = time.past? ? 'преди' : 'след'
    "#{prefix} #{time_ago_in_words time}"
  end
end
