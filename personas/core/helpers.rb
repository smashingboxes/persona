#########################################
#             Core Persona              #
#########################################
#                                       #
#  1. System methods                    #
#  1. Helper methods                    #
#                                       #
#########################################

#########################################
#  1. System Helpers
#########################################    
  
  # Returns the path to the theme currently in use
  def current_theme()
      System.theme
  end
  
  
  # Strips html and returns a string
  def strip_html(str)
      str.gsub(/<\/?[^>]*>/, "")
  end
  
  
  # Reduces a string to a certain number of words and returns a string
  def truncate(str, length=10, strip=false)
    
    str = strip_html(str) if strip

    str = str.split(" ")[0..length].join(" ")
    str += "..." if str.split(" ").length > length   
        
    return str
    
  end
  
  
  # Makes text human readible
  def humanize(str)
    strip_html(str.to_s).gsub("_", " ").split(" ").each{|s| s.capitalize!}.join(" ")
  end
    
  # Looks for a file in the themes folder. If it does not exist, 
  # looks for the file in the proto-includes/views folder. Otherwise,
  # it returns nothing.
  # 
  # filename = The file in question
  #
  # Returns a string
  def look_for(term)
      
      found = ""
         
      # Check the /themes/template directory
      Dir.foreach("./themes/#{current_theme}/") do |cf|
        if cf.split('.').first == term
            found = term
            return found 
        end
      end
      
      # Otherwise, check the default theme
      Dir.foreach("./themes/default/") do |cf|
        if cf.split('.').first == term
          found = "../../themes/default/#{term}" 
          return found
        end
      end
      
      # If it can't find either one, we'll at throw the original term back out
      # for error handling
      return term
      
  end
          
  # Renders a template if it exists, if not it 
  # defaults to the default template in proto-includes
  #
  # filename => The template file to be rendered
  #
  # Returns an action to render a template file
  def proto_genesis(filename="")       
      erb :"#{look_for filename}"
  end
  
  
  # Renders an admin template 
  #
  # filename => The template file to be rendered
  #
  # Returns an action to render a template file
  def admin(filename='index', layout="layout")
      erb :"../../personas/core/views/#{filename.to_s}", :layout => :"../../personas/core/views/#{layout.to_s}"
  end

  
  
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

  
  # Syntax sugar for loading personas into the system
  def load_persona(persona="")
      _file = persona.split("/").last
      require "./personas/#{persona}/#{_file}"
  end
  
  
  # Gets all models and returns an array
  def all_models
      cluster = DataMapper::Model.descendants
  end
  
 
#########################################
#  2. Helpers methods
#########################################  
 
helpers do    
  
  # Renders a link tag with stylesheet information
  #
  # stylesheet => The name of the stylesheet. Defaults to 'screen'
  # media      => The media format the stylesheet will be displayed as.
  #               Defaults to 'screen'
  #
  # Example:
  #   get_stylesheet("print", "print") => <link rel='stylesheet' href='/stylesheets/print.css' media='print'/>
  #
  # Returns an action to render a stylesheet link
  def stylesheet(filename="screen", media="all")
    
    return "<link rel='stylesheet' href='/stylesheets/#{filename}?#{Random.rand(99999999)}' media='#{media}'/>"
  
  end
  
end

