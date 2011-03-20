//= require "vendor/jquery"
//= require "vendor/prettify"

$(function() {
  $('pre:not([class])').addClass('prettyprint lang-python');
  prettyPrint();
});
