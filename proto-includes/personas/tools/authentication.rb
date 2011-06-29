#######################################################
#                 Table of Contents                   #
#######################################################
#                                                     #
# 1) Models                                           #
# 2) Controllers                                      #
# 3) Helper Methods                                   #
# 4) Authentication Workhorse                         #
#                                                     #
#######################################################

require 'sinatra/base'

#######################################################
# 1) Models
#######################################################

class User
    include DataMapper::Resource
    
    property :id,                 Serial
    property :username,           String,                                             :required => true,      :message => "Please specify a username."
    property :password,           String,                                             :required => true,      :message => "Please specify a password."                
    
    property :created_at,         DateTime
    property :updated_at,         DateTime 
    
  end

  DataMapper.finalize
  DataMapper.auto_upgrade!
    
  # Create the default admin
  @user = User.create(
    :username      => "admin",
    :password      => "Smashingid3a",
    :created_at    => Time.now,
    :updated_at    => Time.now
  )


#######################################################
# 2) Controllers
#######################################################

get '/login' do
  erb :login
end

get '/logout' do
  logout()      
  flash[:notice] = "You have successfully logged out."
  redirect "/"
end


#######################################################
# 3) Helpers
#######################################################

helpers do

  def current_user
    session[:current_user]
  end

  def authorized?
    session[:current_user]
  end

  def login
    session[:redirect_to] = request.path_info
    redirect request.script_name + '/login'
  end

  def logout
    session[:current_user] = nil
  end

  def require_user
    login unless authorized?
  end
  
end


#######################################################
# 4) Authentication Workhorse
#######################################################
#  Modified from https://github.com/vangberg/chowder  #
#######################################################

require 'sinatra/base'
require 'ostruct'

module Authentication
  class Base < Sinatra::Base
    disable :raise_errors
    
    require "sinatra/flash"

    def self.new(app=nil, args={}, &block)
      builder = Rack::Builder.new
      builder.use Rack::Session::Cookie, :secret => args[:secret]
      builder.run super
      builder.to_app
    end

    def initialize(app=nil, args={}, &block)
      @signup_callback = args[:signup]
      @login_callback = args[:login] || block
      super(app)
    end

    def authorize(user)
      session[:current_user] = user
    end

    def return_or_redirect_to(path)
      redirect(session[:return_to] || request.script_name + path)
    end

    def render_custom_template(type)
      views_dir = self.options.views || "./views"
      template = Dir[File.join(views_dir, "#{type}.*")].first
      if template
        engine = File.extname(template)[1..-1]
        send(engine, type)
      end
    end

    get '/logout' do
      session[:current_user] = nil
      redirect request.script_name + '/'
    end
  end

  class Basic < Base
  
    post '/login' do
      login, password = params['username'], params['password']
      if authorize @login_callback.call(login, password)  
        return_or_redirect_to '/'
      else
        redirect request.script_name + '/login'
      end
    end

    private
    def signup_view_with_errors(errors)
      SIGNUP_VIEW.gsub(
        /__ERRORS__/,
        errors.map { |e| "<p class=\"error\">#{e}</p>" }.join("\n")
        )
    end
  end
end

use Authentication::Basic,
  :login => lambda {|username, password|
    user = User.first(:username => username, :password => password) and user.id
  }