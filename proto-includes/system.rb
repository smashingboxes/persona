#########################################
#              System.rb                #
#########################################
#                                       #
#########################################


# Takes all items out of a collection and
# requires them
#
# items - A variable number of required file
#         names as strings
#
# Example:
#   require_all "sinatra", "pony", "foo"
#     #=> require "sinatra"
#         require "pony"
#         require "foo" 
#
def require_all(*items)

  items.each do |b|
    require b
  end
  
end