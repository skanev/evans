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


  $('.contribution_input').parent().append '<div class="contribution_preview"></div>'

  throttledPreview = _.throttle ->
    replyBox = $ this
    previewArea = replyBox.siblings '.contribution_preview'

    $.ajax '/preview',
      type: 'POST',
      data: { body: replyBox.val() },
      dataType: 'html',
      success: (data) ->
        previewArea.html data
  , 1000

  $('.contribution_input').on('input', throttledPreview).trigger 'input'
