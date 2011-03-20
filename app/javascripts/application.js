//= require "vendor/jquery"
//= require "vendor/modernizr"
//= require "vendor/prettify"

$(function() {
  $('pre:not([class])').addClass('prettyprint lang-python');
  prettyPrint();
});
