# A nice place for your CoffeeScript,
#
# You can compile via a Rake process using "rake js:compile"
#
#  Have fun!

$(document).ready ->
    
    # To handle flash notification behaviors
    $('.flash').each ->
        index = $(this).index()
        
        $(this).animate({top: "+=" + (60 + (index * 70) )}, 200).fadeTo(500, 0.95).delay(2500).fadeOut(500)
        
        $(this).click ->
            $(this).stop().fadeOut(500)
    
    # Asks the user to confirm they truly want to delete content
    $('a.delete').click ->
        answer = confirm("Are you sure you want to delete this content?")
    
        if !answer
          return false
    
    ##########################################
    #           Get Zeek Behaviors           #
    ##########################################
    
    # Add G
    $('#card-tabs').tabs()
		$( "#accordion" ).accordion()
