// This is a manifest file that'll be compiled into application.js,
// which will include all the files listed below.

//= require jquery
//= require rails_ujs
// require bootstrap


$(document).ready(function() {
  $('#status').fadeOut()
  $('#preloader').delay(350).fadeOut('slow')
  $('body').delay(350).css({ 'overflow': 'visible' })
})
