class SolutionHistory
  def initialize(solution)
    @solution = solution
  end

  def revisions
    @solution.revisions
  end

  def last_revision
    @solution.revisions.last
  end

  def revisions_count
    @solution.revisions.size
  end

  def comments_count
    @solution.comments.size
  end

  def combined_comments
    history = FormattedCode::CommentHistory.new

    @solution.revisions.each do |revision|
      history.add_version revision.code, inline_comments_for(revision)
    end

    history.combined_comments
  end

  def formatted_code
    FormattedCode::Code.new last_revision.code, Language.language, combined_comments
  end

  def formatted_diff_for(previous_revision, revision)
    inline_comments_by_line = inline_comments_for(revision)
    old_code = previous_revision.try(:code) || ''

    FormattedCode::Diff.new old_code, revision.code, Language.language, inline_comments_by_line
  end

  def non_inline_comments_for(revision)
    revision.comments.reject(&:inline?)
  end

  def previous_revision_of(revision)
    revision_index = @solution.revisions.find_index(revision)

    return if revision_index.zero?

    @solution.revisions[revision_index - 1]
  end

  private

  def inline_comments_for(revision)
    revision.comments.select(&:inline?).group_by(&:line_number)
  end
end
