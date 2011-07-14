(function() {
  $(document).ready(function() {
    $('.flash').each(function() {
      var index;
      index = $(this).index();
      $(this).animate({
        top: "+=" + (60 + (index * 70))
      }, 200).fadeTo(500, 0.95).delay(2500).fadeOut(500);
      return $(this).click(function() {
        return $(this).stop().fadeOut(500);
      });
    });
    $('a.delete').click(function() {
      var answer;
      answer = confirm("Are you sure you want to delete this content?");
      if (!answer) {
        return false;
      }
    });
    return $('#card-tabs').tabs();
  });
  $("#accordion").accordion();
}).call(this);
