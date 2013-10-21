$ ->
  $('td:has([data-points])').each ->
    td = $ this
    points = parseInt $('[data-points]', td).text(), 10
    adjustment = parseInt $('[data-adjustment]', td).text(), 10

    td.html ''

    appendPoint = (type) ->
      $('<span class="' + type + '"></span>').appendTo td

    if adjustment >= 0
      [0...points-adjustment].forEach -> appendPoint 'point'
      [0...adjustment].forEach -> appendPoint 'bonus-point'
    else
      [0...points].forEach -> appendPoint 'point'
      [0...-adjustment].forEach -> appendPoint 'penalty-point'


  $('[data-toggleable]').each ->
    toggleable = $ this
    hideText = '▾ ' + toggleable.data 'hide-text'
    showText = '▸ ' + toggleable.data 'show-text'

    link = $('<a href="#">' + hideText + '</a>')
    link.insertBefore toggleable

    link.click ->
      if toggleable.is ':visible'
        toggleable.hide()
        link.text showText
      else
        toggleable.show()
        link.text hideText
      return false
