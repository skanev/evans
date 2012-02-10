# variables to be used from default layout
@title = 'Новини'
@items = @announcements

# methods to be used from default layout
def item_path(announcement, args)
  announcement_path announcement, args
end
