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


# Renders a template if it exists, if not it 
# defaults to the default template in proto-includes
#
# filename => The template file to be rendered
#
# Returns an action to render a template file
def proto_genesis(filename)
    
    proto_path = "../../proto-includes/views"
    
    if File.file? filename
        erb :"#{filename}"
    else
        flash[:'permanent notice'] = "<strong>Using defaults</strong> This message will not display in production mode" unless ENV['RACK_ENV'] == 'production'
        
        #sanitize 'filename'
        filename[0] = "" if filename[0] == "/"
        
        erb :"#{proto_path + '/' + filename}"
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
  
  
  # Renders a link tag with stylesheet information
  #
  # stylesheet => The name of the stylesheet. Defaults to 'screen'
  # media      => The media format the stylesheet will be displayed as.
  #               Defaults to 'screen'
  #
  # Example:
  #   get_stylesheet("print", "print")
  #       # => <link rel='stylesheet' href='/stylesheets/print.css' media='print'/>
  #
  # Returns an action to render the admin menu template
  def get_stylesheet(stylesheet="screen", media="screen")
    return "<link rel='stylesheet' href='/stylesheets/#{stylesheet}.css' media='#{media}'/>"  
  end

end