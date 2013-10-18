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

    function visible() {
        $(this).html('▾ Скрий лога');
        testLog.show();
        $(this).click(hidden);
        return false;
    }

    function hidden() {
        $(this).html('▸ Покажи лога');
        testLog.hide();
        $(this).click(visible);
        return false;
    }

    $('<a href="#"></a>')
      .click(visible)
      .insertBefore(testLog)
      .click();
  });

  $('[data-revision-code]').each(function() {
    var codeBlock = $(this);

    function visible() {
        $(this).html('▾ Скрий кода');
        codeBlock.show();
        $(this).click(hidden);
        return false;
    }

    function hidden() {
        $(this).html('▸ Покажи кода');
        codeBlock.hide();
        $(this).click(visible);
        return false;
    }

    $('<a href="#" class="show-code"></a>')
      .click(visible)
      .insertBefore(codeBlock)
      .click();
  });
});
