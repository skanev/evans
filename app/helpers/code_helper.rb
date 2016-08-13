module CodeHelper
  def format_code(code)
    CodeRay.scan(code, Language.language).html(
      line_numbers: :table,
      bold_every: false,
      line_number_anchors: false,
      css: :class
    ).html_safe
  end

  def code_with_comments(formatted_code, commentable, form_partial=nil, *form_partial_args)
    render '_formatted_code/code', code: formatted_code, commentable: commentable,
                                   form_partial: form_partial, form_partial_args: form_partial_args
  end

  def revision_code_with_comments(revision, commentable)
    code = revision.formatted_code

    code_with_comments code, commentable, 'solutions/inline_comment_form', revision: revision.model
  end

  def revision_diff_with_comments(revision, commentable)
    code = revision.formatted_diff

    code_with_comments code, commentable, 'solutions/inline_comment_form', revision: revision.model
  end

  def inline_comment(comment)
    render '_formatted_code/inline_comment', comment: InlineCommentDecorator.decorate(comment)
  end
end
