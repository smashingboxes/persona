#######################################################
#                     System.rb                       #
#######################################################
#                                                     #
#######################################################
#                 Table of Contents                   #
#######################################################
#                                                     #
# 1) System Helpers                                   #
# 2) Helpers                                          #
#                                                     #
#######################################################

#######################################################
# 1) System Helpers
#######################################################
    
    
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
    
    
    # Returns the filepath for the proto-includes views folder
    def proto_path()
        proto_path = "../../proto-includes/"
    end
    
    
    # Looks for a file in the themes folder. If it does not exist, 
    # looks for the file in the proto-includes/views folder. Otherwise,
    # it returns nothing.
    # 
    # filename = The file in question
    #
    # Returns a string
    def look_for(filename="")
        
        # Check the /themes/template directory 
        if File.file? ("./themes/" + current_theme + filename)
            filename
        else File.file? (proto_path + filename)            
            
            #sanitize 'filename'
            filename[0] = "" if filename[0] == "/"
            
            "#{proto_path + filename}"
        end
        
    end
    
    # Renders a template if it exists, if not it 
    # defaults to the default template in proto-includes
    #
    # filename => The template file to be rendered
    #
    # Returns an action to render a template file
    def proto_genesis(filename="")
            
        seed = look_for filename
        
        erb :"#{seed}"
        
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
    
    # Returns the path to the theme currently in use
    def current_theme()
        System.theme
    end


#######################################################
# 2) Template Helpers
#######################################################

  helpers do    
    
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
    def get_stylesheet(filename="screen", media="screen")
      
      filename += ".css"
      
      return "<link rel='stylesheet' href='/stylesheets/#{filename}' media='#{media}'/>"
    
    end
  
  end
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  