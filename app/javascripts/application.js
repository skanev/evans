//= require "vendor/jquery"
//= require "vendor/jquery.ujs"
//= require "vendor/modernizr"
//= require "vendor/prettify"

//= require "tasks"

$(function() {
  $('pre:not([class])').addClass('prettyprint lang-python');
  prettyPrint();
});
