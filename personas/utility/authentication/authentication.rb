#######################################################
#  Persona Authentication Workhorse
#######################################################
#  Modified from https://github.com/vangberg/chowder  #
#######################################################

require 'sinatra/base'
require 'ostruct'

module Persona::Authentication
    
  # Helper methods
  def current_user
    
    # First, let's try to get the current user
    user_id = session[:current_user]
    
    # Next we test to see if it actually exists
    # If not, we queue up the login screen to prevent an error
    if user_id
      User.get(session[:current_user])
    else
      login
    end
    
  end
  
  def authorized?
    session[:current_user]
  end
  
  def login
    redirect '/admin/login'
  end
  
  def logout
    session[:current_user] = nil
  end
  
  def require_user
    login unless authorized?
  end
    
  class Base < Persona::Base
    
    disable :raise_errors
      
    def self.new(app=nil, args={}, &block)
      builder = Rack::Builder.new
      builder.use Rack::Session::Cookie, :secret => args[:secret]
      builder.run super
      builder.to_app
    end
  
    def initialize(app=nil, args={}, &block)
      @login_callback = args[:login] || block
      super(app)
    end
  
    def authorize(user)
      session[:current_user] = user
    end
  
    get '/logout' do
      session[:current_user] = nil
      redirect '/'
    end
    
  end
  
  class Basic < Persona::Authentication::Base
        
    post '/login' do
      login, password = params['username'], params['password']
      if authorize @login_callback.call(login, password)
        flash[:success] = "Welcome, <strong>#{params[:username]}</strong>."
        redirect '/admin'
      else
        flash[:error] = "<strong>Error:</strong> Please provide a valid username and password"
        redirect '/admin/login'
      end
    end
  
  end
end