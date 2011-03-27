$(function() {
  $('td:has([data-points])').each(function() {
    var td = $(this);
    var points = parseInt($('[data-points]', td).text(), 10);

    td.html('');

    for(var i = 0; i < points; i++) {
      $('<span class="point"></span>').appendTo(td);
    }
  });
});
