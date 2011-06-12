# A nice place for your CoffeeScript,
#
# Prototypical will watch for CoffeeScript files for you and
# automatically compile them. Have fun!

$(document).ready ->
    
    $('.flash').each ->
        index = $(this).index()
        
        if index != 0
            $(this).css("padding-left", 20)
        
        $(this).animate({top: "+=" + index * 70}, 200).fadeTo(500, 0.95).delay(2500).fadeOut(500)
        
        $(this).click ->
            $(this).stop().fadeOut(500)
    
    config = {    
         over: -> $("#admin").stop().animate({height: 210}, 250),   
         timeout: 100, 
         out: -> $("#admin").stop().animate({height: 37}, 300)    
    };

    $('#admin').hoverIntent(config)
        
    $('a.delete').click ->
        answer = confirm("Are you sure you want to delete this page?")
    
        if !answer
          return false