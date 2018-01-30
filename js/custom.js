$('#logo').click(function(){
  console.log('test');
	$('html, body').animate({scrollTop : -51},800);
	return false;
});
// $(".page-scroll").on('click', function(e) {
//   e.preventDefault();
//   var hash = this.hash;
//   var scrollPos = $(this.hash).offset().top - 51
//   $('html, body').animate({
//     scrollTop: scrollPos
//   }, 750, function() {
//     window.location.hash = hash;
//   });
// });
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
$('.navbar-nav>li>a').on('click', function(){
    $('.navbar-collapse').collapse('hide');
});
wow = new WOW();
wow.init();
