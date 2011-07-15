# A nice place for your CoffeeScript,
#
# You can compile via a Rake process using "rake js:compile"
#
#  Have fun!

$(document).ready ->
    
    # To handle flash notification behaviors
    $('.flash').each ->
        index = $(this).index()
        
        $(this).animate({top: "+=" + (90 + (index * 70) )}, 200).fadeTo(500, 0.95)
        
        $(this).hover( 
          -> $(this).stop().fadeIn()
          -> $(this).stop().delay(1000).fadeOut()
        )
        
        $(this).click ->
            $(this).stop().fadeOut(500)
    
    # Asks the user to confirm they truly want to delete content
    $('a.delete').click ->
        answer = confirm("Are you sure you want to delete this?")
    
        if !answer
          return false