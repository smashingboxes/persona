#######################################################
#                 Table of Contents                   #
#######################################################
#                                                     #
# 1) Models                                           #
#                                                     #
#######################################################

module Persona
  
  class Painter < Persona::Base
    
    # Change the default directories to point to "admin"
    set :views,  Proc.new  { File.join("#{File.dirname(__FILE__)}") }
    
    get '/' do
      erb :index, :layout => :'../../administrator/views/layout'
    end
    
    get '/datamodel' do
      erb :datamodel, :layout => :'../../administrator/views/layout'
    end
    
    get '/type' do
      erb :type, :layout => :'../../administrator/views/layout'
    end

  end

end