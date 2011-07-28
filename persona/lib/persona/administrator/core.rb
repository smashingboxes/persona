#########################################
#         Administrator Persona         #
#########################################
#                                       #
#########################################  

module Persona

  class Administrator < Persona::Base
        
    # Requirements
    load_persona "utility/authentication"
  
    require_all 'maruku',                   # => For interpretting Markdown
                'coffee-script'             # => For interpreting CoffeeScript
    
    # Change the default directories to point to "admin"
    set :views,   Proc.new  { File.join("#{File.dirname(__FILE__)}", "views") }
    set :public,  Proc.new  { File.join("#{File.dirname(__FILE__)}", "views") }
    set :layout,  Proc.new  { File.join("#{File.dirname(__FILE__)}", "views") }

    
    # Load core files
    require  "persona/administrator/controller" 
    
  end
  
end