# variables to be used from default layout
@title = 'Материали'
@items = @lectures

# methods to be used from default layout
def get_item_title(lecture)
  lecture_title lecture
end

def item_path(lecture, args)
  lecture_url lecture
end
