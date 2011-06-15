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
    $('#admin-toggle #icon').toggle(function() {
      return $("#admin-overlay").stop().fadeIn();
    }, function() {
      return $("#admin-overlay").stop().fadeOut();
    });
    $("#admin-overlay").click(function() {
      return $(this).fadeOut();
    });
    return $('a.delete').click(function() {
      var answer;
      answer = confirm("Are you sure you want to delete this page?");
      if (!answer) {
        return false;
      }
    });
  });
}).call(this);
