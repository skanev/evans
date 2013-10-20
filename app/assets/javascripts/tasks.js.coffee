$ ->
  $('td:has([data-points])').each ->
    td = $ this
    points = parseInt $('[data-points]', td).text(), 10
    adjustment = parseInt $('[data-adjustment]', td).text(), 10

    td.html ''

    if adjustment >= 0
      for i in [0...points-adjustment]
        $('<span class="point"></span>').appendTo td
      for i in [0...adjustment]
        $('<span class="bonus-point"></span>').appendTo td
    else
      for i in [0...points]
        $('<span class="point"></span>').appendTo td
      for i in [0...-adjustment]
        $('<span class="penalty-point"></span>').appendTo td


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
