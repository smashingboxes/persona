#########################################
#             Core Persona              #
#########################################
#                                       #
#    1) File Helpers                    #
#        a) require_all                 #
#                                       #
#    2) String Helpers                  #
#        a) strip_html                  #
#        b) truncate                    #
#        c) humanize                    #
#                                       #
#    4) File/Data Helpers               #
#        a) themes                      #
#        b) all_models                  #
#        c) current_theme               #
#        d) load_persona                #
#        e) load_personas               #
#        f) find_name                   #
#                                       #
#########################################

module Persona::Core
                      
    #########################################
    #  1. File Helpers
    #########################################
      
        # a) require_all
        #
        #    Takes all items out of a collection and
        #    requires them
        #
        def require_all(*items)
          items.each do |i|
            require i
          end
        end
        
    #########################################
    #  2. String Helpers
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
    #  4. Data Helpers
    #########################################
    
        # a) themes 
        #
        #    Scans for all folders files in the themes directory
        #    and returns an array of string-value names
        #
        def themes()
          source = "./themes/"
          
          cluster = []
          
          if File.directory? source
            Dir.foreach(source) do |cf|
              unless cf == '.' || cf == '..' 
                cluster << cf.split('.').first
              end 
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
        def load_persona(persona)
            puts "\nLoading persona \"#{humanize persona}\"..."
            require "persona/#{persona}/core"            
        end
        
        # e) load_persona 
        #
        #    Syntax sugar for loading personas into the system
        #
        def load_personas(*personas)
          personas.each do |p|
            puts "\nLoading \"#{humanize p.to_s}\"..." 
            require "persona/#{p.to_s}/core"            
          end
        end
        
        # f) find_name 
        #
        #    helps to determine if a model has a "name" or "title" 
        #    attribute
        #
        def find_name(object)
          object.attributes.each do |a|
            if a[0].to_s =~ /(name|title)\z/i
              return a[1].to_s 
            end
          end
        end
        
        
end