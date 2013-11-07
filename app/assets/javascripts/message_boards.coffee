$ ->
  $('[data-starred]')
    .bind 'updateStarStatus', ->
      post = $ this
      post_li = post.closest 'li'

      post.find('[data-toggle-star]').hide()

      if post.data 'starred'
        post_li.addClass 'starred'
        post.find('[data-toggle-star=unstar]').show()
      else
        post_li.removeClass 'starred'
        post.find('[data-toggle-star=star]').show()

    .trigger 'updateStarStatus'


  $('[data-toggle-star]').on 'ajax:success', (e, data) ->
    link = $ this
    post = link.closest '[data-starred]'

    post
      .data('starred', data.starred)
      .trigger 'updateStarStatus'
