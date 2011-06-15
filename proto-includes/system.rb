#########################################
#              System.rb                #
#########################################
#                                       #
#########################################


# Takes all items out of a collection and
# requires them
#
# collection - The array or string to pull
#              required files from
#
def require_all(*items)

  items.each do |b|
    require b
  end
  
end