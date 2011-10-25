/*
 *= require jquery
 *= require jquery_ujs
 *= require modernizr
 *= require underscore
 *= require highlight
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
  $('pre:not([class])').addClass('language-ruby').each(function () {
    hljs.highlightBlock(this);
  });
});
