module CustomPaths
  def solution_path(solution)
    task_solution_path(solution.task, solution)
  end

  def solution_url(solution)
    task_solution_url(solution.task, solution)
  end
end
