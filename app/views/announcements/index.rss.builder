# variables to be used from default layout
@title = 'Новини'
@items = @announcements

# methods to be used from default layout
def feed_path(announcement)
  announcement_path announcement, :only_path => false
end
