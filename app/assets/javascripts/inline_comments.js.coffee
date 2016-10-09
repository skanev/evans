$ ->
  $('.js-code-with-comments').each ->
    code = $ this
    form = code.find '[data-inline-comment-form]'

    code.find('[data-add-comment]').click ->
      line = $(this).parents '.line'
      lineNumber = parseInt(line.data('line-number'), 10) - 1
      comments = line.find '[data-code-comments]'

      code.find('[data-reply-button]').show()
      line.find('[data-reply-button]').hide()

      form.appendTo comments
      form.show()

      comments.find('textarea').focus()
      comments.find('.line-number-input').val(lineNumber)

    code.on 'click', '[data-close-comment-form]', ->
      line = $(this).parents '.line'

      form.find('[name="comment[body]"]').val ''
      form.hide()
      line.find('[data-reply-button]').show()
