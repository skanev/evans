/*
 *= require jquery
 *= require jquery_ujs
 *= require modernizr
 *= require underscore
 *= require highlight
 *= require highcharts
 *
 *= require_self
 *
 *= require message_boards
 *= require tasks
 *= require statistics
 */

$.ajaxSetup({
  dataType: 'json'
});

$(function() {
  $('pre:not([class])').addClass('language-ruby').each(function () {
    hljs.highlightBlock(this);
  });
});
