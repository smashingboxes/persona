# A nice place for your CoffeeScript,
#
# Prototypical will watch for CoffeeScript files for you and
# automatically compile them.
#
# You can compile via a Rake process using "rake js:compile"
#
#  Have fun!

$(document).ready ->
    
    $('.flash').each ->
        index = $(this).index()
        
        $(this).animate({top: "+=" + (60 + (index * 70) )}, 200).fadeTo(500, 0.95).delay(2500).fadeOut(500)
        
        $(this).click ->
            $(this).stop().fadeOut(500)

    $('#admin-toggle #icon').toggle(
      -> $("#admin-overlay").stop().fadeIn(),
      -> $("#admin-overlay").stop().fadeOut()
    )
    
    $("#admin-overlay").click ->
      $(this).fadeOut()
    
    $('a.delete').click ->
        answer = confirm("Are you sure you want to delete this page?")
    
        if !answer
          return false