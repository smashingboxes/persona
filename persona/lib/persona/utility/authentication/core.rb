#######################################################
#                 Table of Contents                   #
#######################################################
#                                                     #
#######################################################

module Persona
  
  require "#{File.dirname(__FILE__)}/authentication"
  
  class Base < Sinatra::BigBand
  
    include Persona::Authentication
  
  end
  
  # Extend the administrator to include login/logout
  class Administrator < Persona::Base
    
    # Change the default directories to point to "admin"        
    require "#{File.dirname(__FILE__)}/model.rb"
    
    use Persona::Authentication::Basic, :login => lambda {|username, password|
      user = User.first(:username => username, :password => password) and user.id
    }
    
    get '/login' do      
      erb :login, :layout => :safety, :views => "#{File.dirname(__FILE__)}/views/"
    end
    
    get '/logout' do
      logout
         
      flash[:notice] = "You have successfully logged out."
      redirect "/"
    end

  end
end