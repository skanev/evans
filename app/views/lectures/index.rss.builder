# variables to be used from default layout
@title = 'Материали'
@items = @lectures

# methods to be used from default layout
def feed_body(lecture)
  link_to lecture.title, lecture.url
end
