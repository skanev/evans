module CustomPaths
  def solution_path(solution)
    task_solution_path(solution.task, solution)
  end

  def solution_url(solution)
    task_solution_url(solution.task, solution)
  end

  def comment_path(comment)
    task_solution_url(comment.solution.task, comment.solution, anchor: "comment-#{comment.id}")
  end

  def comment_url(comment)
    task_solution_url(comment.solution.task, comment.solution, anchor: "comment-#{comment.id}")
  end
end
