# variables to be used from default layout
@title = 'Форуми'
@items = @posts

# methods to be used from default layout
def feed_path(post)
  topic_path post, :only_path => false
end
