# A nice place for your CoffeeScript,
#
# Prototypical will watch for CoffeeScript files for you and
# automatically compile them. Have fun!

$('.flash').fadeTo(500, 0.95).delay(2500).fadeOut(500)
$('.flash').click ->
    $(this).stop().fadeOut(500)

$('#admin').hover(
    -> $("#admin").stop().animate({height: 130}, 250),
    -> $("#admin").stop().animate({height: 37}, 250)
)

$('a.delete').click ->
    answer = confirm("Are you sure you want to delete this page?")

    if !answer
      return false