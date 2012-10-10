class SolutionHistory
  def initialize(solution)
    @solution = solution
  end

  def revisions
    @solution.revisions
  end

  def revisions_count
    @solution.revisions.count
  end

  def comments(revision)
    revision.comments
  end

  def comments_count
    @solution.comments.count
  end

  def code_for(revision)
    revision.code
  end
end
