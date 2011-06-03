(function() {
  $('.flash').fadeTo(500, 0.95).delay(2500).fadeOut(500);
  $('.flash').click(function() {
    return $(this).stop().fadeOut(500);
  });
  $('#admin').hover(function() {
    return $("#admin").stop().animate({
      height: 130
    }, 250);
  }, function() {
    return $("#admin").stop().animate({
      height: 37
    }, 250);
  });
  $('a.delete').click(function() {
    var answer;
    answer = confirm("Are you sure you want to delete this page?");
    if (!answer) {
      return false;
    }
  });
}).call(this);
