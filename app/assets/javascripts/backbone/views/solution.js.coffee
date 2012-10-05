class App.Views.Solution extends Backbone.View
  events:
    'mouseenter tr': 'showCommentLink'
    'mouseleave tr': 'hideCommentLink'

  initialize: ->
    @addCommentLinks()

  render: ->
    this

  addCommentLinks: ->
    $('td:first-child', @el).each (index) ->
      lineNumber = index + 1
      $(this)
        .html("""<span>#{-lineNumber}</span><a href="#" class="row-comment" data-comment-row="#{lineNumber}">Comment</a>""")
        .find('[data-comment-row]')
        .hide()

  showCommentLink: (e) ->
    row = $(e.currentTarget)
    row.find('td:first-child span').hide()
    row.find('td:first-child [data-comment-row]').show()

  hideCommentLink: (e) ->
    row = $(e.currentTarget)
    row.find('td:first-child span').show()
    row.find('td:first-child [data-comment-row]').hide()
