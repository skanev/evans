class SolutionHistory
  def initialize(solution)
    @solution = solution
  end

  def revisions
    @solution.revisions
  end

  def comments(revision)
    revision.comments
  end

  def code_for(revision)
    revision.code
  end
end
