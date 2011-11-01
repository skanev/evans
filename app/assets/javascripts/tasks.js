$(function() {
  $('td:has([data-points])').each(function() {
    var td         = $(this),
        points     = parseInt($('[data-points]', td).text(), 10),
        adjustment = parseInt($('[data-adjustment]', td).text(), 10);

    td.html('');


    if (adjustment >= 0) {
      for(var i = 0; i < points - adjustment; i++) {
        $('<span class="point"></span>').appendTo(td);
      }
      for(var i = 0; i < adjustment; i++) {
        $('<span class="bonus-point"></span>').appendTo(td);
      }
    } else if (adjustment < 0) {
      for(var i = 0; i < points; i++) {
        $('<span class="point"></span>').appendTo(td);
      }
      for(var i = 0; i < -adjustment; i++) {
        $('<span class="penalty-point"></span>').appendTo(td);
      }
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
