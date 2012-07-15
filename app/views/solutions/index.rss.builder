# variables to be used from default layout
@title = "Решения на #{@task.name}"
@items = @task.comments

# methods to be used from default layout
def feed_path(comment)
  task_solution_path @task, comment.solution, :only_path => false, :anchor => "comment-#{comment.id}"
end

def feed_title(comment)
  "Коментар към решение на #{comment.solution.user_name} от #{comment.user_name}"
end
