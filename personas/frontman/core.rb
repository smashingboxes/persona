#########################################
#           Architect Persona           #
#########################################
#                                       #
#########################################  

module Persona

  class Frontman < Persona::Base
    
    # Change the default directories to point to "themes"
    set :views,  Proc.new  { File.join("themes/#{System.theme}") }
    set :public, Proc.new  { File.join("themes/#{System.theme}") }
    set :layout, Proc.new  { File.join("themes/#{System.theme}") }
    
    # Root Directory
    get '/' do
      erb :index
    end
    
  end
  
end