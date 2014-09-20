$ ->
  $('[data-starred]')
    .bind 'updateStarStatus', ->
      contribution = $ this

      contribution.find('[data-toggle-star]').hide()

      if contribution.data 'starred'
        contribution.addClass 'starred'
        contribution.find('[data-toggle-star=unstar]').show()
      else
        contribution.removeClass 'starred'
        contribution.find('[data-toggle-star=star]').show()

    .trigger 'updateStarStatus'


  $('[data-toggle-star]').on 'ajax:success', (e, data) ->
    link = $ this
    contribution = link.closest '[data-starred]'

    contribution
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
