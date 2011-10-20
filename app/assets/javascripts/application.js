/*
 *= require jquery
 *= require jquery_ujs
 *= require modernizr
 *
 *= require_self
 *
 *= require message_boards
 *= require tasks
 */

$.ajaxSetup({
  dataType: 'json'
});

$(function() {
  $('pre:not([class])').addClass('prettyprint lang-python');
});
