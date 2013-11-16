$ ->
  $('[data-starred]')
    .bind 'updateStarStatus', ->
      post = $ this
      postLi = post.closest 'li'

      post.find('[data-toggle-star]').hide()

      if post.data 'starred'
        postLi.addClass 'starred'
        post.find('[data-toggle-star=unstar]').show()
      else
        postLi.removeClass 'starred'
        post.find('[data-toggle-star=star]').show()

    .trigger 'updateStarStatus'


  $('[data-toggle-star]').on 'ajax:success', (e, data) ->
    link = $ this
    post = link.closest '[data-starred]'

    post
      .data('starred', data.starred)
      .trigger 'updateStarStatus'


  $('[data-contribution-input]').on 'input', _.throttle ->
    replyBox = $ this
    previewArea = $ '[data-contribution-preview]'

    $.ajax '/preview',
      type: 'POST',
      data: { body: replyBox.val() },
      dataType: 'html',
      success: (data) ->
        previewArea.html data
  , 1000
