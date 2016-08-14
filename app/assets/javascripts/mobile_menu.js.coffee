$ ->
  body = $ document.body

  $('[data-toggle-mobile-menu]').on 'click', (event) ->
    body.toggleClass 'mobile-menu-open'
    event.stopPropagation()

  $('.js-site-content-overlay').on 'click', (event) ->
    body.removeClass 'mobile-menu-open'
    event.preventDefault()
