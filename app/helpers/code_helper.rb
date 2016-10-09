module CodeHelper
  def format_code(code_text, language = Language.language)
    formatted_code = FormattedCode::Code.new(code_text, language, [])

    render '_formatted_code/code', code: formatted_code, commentable: false
  end

  def code_with_comments(formatted_code, commentable, form_partial = nil, *form_partial_args)
    render '_formatted_code/code', code: formatted_code, commentable: commentable,
                                   form_partial: form_partial, form_partial_args: form_partial_args
  end

  def solution_code(formatted_code, revision, commentable)
    code_with_comments formatted_code, commentable, 'solutions/inline_comment_form',
                       revision: revision
  end

  def inline_comment(comment)
    render '_formatted_code/inline_comment', comment: InlineCommentDecorator.decorate(comment)
  end
end
