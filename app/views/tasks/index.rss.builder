# variables to be used from default layout
@title = 'Задачи'
@items = @tasks

# methods to be used from default layout
def feed_path(task)
  task_path task, :only_path => false
end

def feed_title(task)
  task.name
end

def feed_body(task)
  render task
end
