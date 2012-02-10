# variables to be used from default layout
@title = 'Материали'
@items = @lectures

# methods to be used from default layout
def item_path(lecture, args)
  lecture.url
end
