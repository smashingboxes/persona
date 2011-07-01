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


helpers do

  # Scans for all folders files in the themes directory 
  #
  # Return an array of strings equal to theme names
  def themes()
    source = "./themes/"
    
    cluster = []
    
    Dir.foreach(source) do |cf|
      unless cf == '.' || cf == '..' 
        cluster << cf.split('.').first
      end 
    end
    
    return cluster
  end

end