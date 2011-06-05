(function() {
  $(document).ready(function() {
    var config;
    $('.flash').each(function() {
      var index;
      index = $(this).index();
      if (index !== 0) {
        $(this).css("padding-left", 20);
      }
      $(this).animate({
        top: "+=" + index * 70
      }, 200).fadeTo(500, 0.95).delay(2500).fadeOut(500);
      return $(this).click(function() {
        return $(this).stop().fadeOut(500);
      });
    });
    config = {
      over: function() {
        return $("#admin").stop().animate({
          height: 210
        }, 350);
      },
      timeout: 500,
      out: function() {
        return $("#admin").stop().animate({
          height: 37
        }, 500);
      }
    };
    $('#admin').hoverIntent(config);
    return $('a.delete').click(function() {
      var answer;
      answer = confirm("Are you sure you want to delete this page?");
      if (!answer) {
        return false;
      }
    });
  });
}).call(this);
