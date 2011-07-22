#########################################
#             Core Persona              #
#########################################
#                                       #
#   I. System methods                   #
#       1) String Helpers               #
#           a) strip_html               #
#           b) truncate                 #
#           c) humanize                 #
#                                       #
#       2) Rendering Helpers            #
#           a) proto_genesis            #
#           b) admin                    #
#                                       #
#       3) File/Data Helpers            #
#           a) themes                   #
#           b) all_models               #
#           c) current_theme            #
#           d) load_persona             #
#                                       #
#                                       #
#  II. Helper methods                   #
#                                       #
#########################################

#########################################
#  I. System Helpers
######################################### 

    #########################################
    #  1. String Helpers
    #########################################   
    
        # a) strip_html
        #
        #    Receives a string and removes all html elements
        #
        def strip_html(str)
            str.gsub(/<\/?[^>]*>/, "")
        end
        
        
        # b) truncate:
        #
        #    Reduces a string to a certain number of words and returns a string
        #
        def truncate(str, length=10, strip=false)
          
          str = strip_html(str) if strip
      
          str = str.split(" ")[0..length].join(" ")
          str += "..." if str.split(" ").length > length   
              
          return str
          
        end
        
        
        # c) humanize:
        #
        #    Makes text human readible by replacing "_" and capitalizing words
        #
        def humanize(str)
          strip_html(str.to_s).gsub("_", " ").split(" ").each{|s| s.capitalize!}.join(" ")
        end
  
  
    #########################################
    #  2. Rendering Helpers
    #########################################
                
        # a) proto_genesis
        #
        #    Trys to render a template if it exists.
        #    If not it tries the default template
        #
        def proto_genesis(filename="")       
            erb :"#{filename}"
            erb :"../default/#{filename}"
        end
        
        
        # b) admin
        #
        #    Requires user authentication and renders
        #    an admin template, 
        #
        def admin(filename='index', layout="layout")
            require_user
            erb :"../../personas/core/views/#{filename.to_s}", :layout => :"../../personas/core/views/#{layout.to_s}"
        end


    #########################################
    #  3. File/Data Helpers
    #########################################

        # a) themes 
        #
        #    Scans for all folders files in the themes directory
        #    and returns an array of string-value names
        #
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
              
              
        # b) all_models
        #
        #    Gets all descendants of the DataMapper::Model
        #    class and returns an array of classes
        #
        def all_models
            cluster = DataMapper::Model.descendants
        end
        
        
        # c) current_theme
        #
        #    Returns the name to the theme currently in use
        #
        def current_theme()
            System.theme
        end
  
  
        # d) load_persona 
        #
        #    Syntax sugar for loading personas into the system
        #
        def load_persona(persona="")
            _file = persona.split("/").last
            require "./personas/#{persona}/#{_file}"
        end
        
 

#########################################
#  2. Helpers methods
#########################################  
 
 
    helpers do    
      
      # 1) stylesheet
      #    
      #    Renders a link tag with stylesheet information
      #
      #    stylesheet => The name of the stylesheet. Defaults to 'screen'
      #    media      => The media format the stylesheet will be displayed as.
      #                  Defaults to 'screen'
      #
      # Returns an action to render a stylesheet link
      def stylesheet(filename="screen", media="all")
        
        return "<link rel='stylesheet' href='/stylesheets/#{filename}?#{Random.rand(99999999)}' media='#{media}'/>"
      
      end
      
    end
    
