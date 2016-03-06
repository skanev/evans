module CodeHelper
  def format_code(code)
    CodeRay.scan(code, Language.language).html(
      line_numbers: :table,
      bold_every: false,
      line_number_anchors: false,
      css: :class
    ).html_safe
  end

  def formatted_code_lines(code)
    code_html = CodeRay.scan(code, Language.language).html(wrap: nil)

    code_html.split("\n").map(&:html_safe)
  end

  def code_with_comments(revision, commentable)
    comments_by_lines = revision.comments.group_by(&:line_number)

    render 'solutions/code_with_comments', revision:          revision,
                                           commentable:       commentable,
                                           comments_by_lines: comments_by_lines
  end

  def inline_comment(comment)
    render 'solutions/inline_comment', comment: InlineCommentDecorator.decorate(comment)
  end
end
