$(function() {
  $('td:has([data-points])').each(function() {
    var td = $(this);
    var points = parseInt($('[data-points]', td).text(), 10);

    td.html('');

    for(var i = 0; i < points; i++) {
      $('<span class="point"></span>').appendTo(td);
    }
  });

  $('[data-test-log]').each(function() {
    var testLog = $(this);

    $('<a href="#"></a>')
      .toggle(
        function() { $(this).html('▸ Покажи лога'); testLog.hide(); },
        function() { $(this).html('▾ Скрий лога'); testLog.show(); }
      )
      .click()
      .insertBefore(testLog);
  });
});
