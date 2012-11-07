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

  $('[data-revision-code]').each(function() {
    var codeBlock = $(this);

    $('<a href="#" class="show-code"></a>')
      .toggle(
        function() { $(this).html('▸ Покажи кода'); codeBlock.hide(); },
        function() { $(this).html('▾ Скрий кода'); codeBlock.show(); }
      )
      .click()
      .insertBefore(codeBlock);
  });
  
  $('[data-current-solution]').each(function() {
    var codeBlock       = $(this), 
        codeLineNumbers = codeBlock.find('td:even');

    $('<a href="#" class="toggle-numbers"></a>')
      .toggle(
        function() { $(this).html('Скрий номерата'); codeLineNumbers.show(); },
        function() { $(this).html('Покажи номерата'); codeLineNumbers.hide(); }
      )
      .click()
      .insertBefore(codeBlock);
  });
});
