# variables to be used from default layout
@title = 'Форуми'
@items = @posts

# methods to be used from default layout
def item_path(post, args)
  topic_path post, args
end
