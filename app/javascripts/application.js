//= require "vendor/jquery"
//= require "vendor/modernizr"
//= require "vendor/prettify"

//= require "tasks"

$(function() {
  $('pre:not([class])').addClass('prettyprint lang-python');
  prettyPrint();
});
