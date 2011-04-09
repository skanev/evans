//= require "vendor/jquery"
//= require "vendor/jquery.ujs"
//= require "vendor/modernizr"
//= require "vendor/prettify"

//= require "tasks"

$.ajaxSetup({
  dataType: 'json'
});

$(function() {
  $('pre:not([class])').addClass('prettyprint lang-python');
  prettyPrint();
});
