$('#logo').click(function() {
  var $anchor = $(this);
  var $width = jQuery(window).width();
  if ($width < 567) {
    var scrollPos = 0;
  } else {
    var scrollPos = -51;
  }
  $('html, body').animate({
    scrollTop: scrollPos
  }, 1250);
  return false;
});
$('a.page-scroll').bind('click', function(event) {
  var w = jQuery(window).width()
  var $anchor = $(this);
  if (w < 567) {
    var scrollPos = ($($anchor.attr('href')).offset().top - 51);
  } else {
    var scrollPos = ($($anchor.attr('href')).offset().top);
  }
  $('html, body').stop().animate({
    scrollTop: scrollPos
  }, 1250);
  event.preventDefault();
});
$('.navbar-nav>li>a').on('click', function() {
  $('.navbar-collapse').collapse('hide');
});
wow = new WOW();
wow.init();
