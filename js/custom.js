$(".page-scroll").on('click', function(e) {
  e.preventDefault();
  var hash = this.hash;
  $('html, body').animate({
    scrollTop: $(this.hash).offset().top - 56
  }, 750, function() {
    window.location.hash = hash;
  });
});
$('.navbar-nav>li>a').on('click', function(){
    $('.navbar-collapse').collapse('hide');
});
wow = new WOW();
wow.init();
