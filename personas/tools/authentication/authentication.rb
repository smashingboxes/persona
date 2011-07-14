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
  
  property :username,           String,                   :required => true,      :message => "Please specify a username."
  property :password,           String,                   :required => true,      :message => "Please specify a password."                
  
  property :first_name,         String
  property :last_name,          String
  
  # Account permissions level
  # 
  # 0 - # General User  =>   No privileges
  # 1 - # Contributer   =>   Create, Edit, Delete own posts
  # 2 - # Editor        =>   Create, Edit, Delete all posts
  # 4 - # Admin         =>   Create, Edit, Delete all non-admin users and posts
  # 5 - # Superadmin    =>   Create, Edit, Delete all users and posts
  
  property :account_level,      Integer,                  :required => true,      :default => 0
  
  property :created_at,         DateTime
  property :updated_at,         DateTime 
  
end

DataMapper.finalize
DataMapper.auto_upgrade!

if User.all.count == 0 
    # Create the default admin
    @user = User.create(
      :account_level => 5,
      :username      => "admin",
      :password      => "Smashingid3a",
      :first_name    => "Persona",
      :last_name     => "Admin",
      :created_at    => Time.now,
      :updated_at    => Time.now
    )
    
    # Create the default admin
    @nate = User.create(
      :account_level => 5,
      :username      => "nate",
      :password      => "Smashingid3a",
      :first_name    => "Nate",
      :last_name     => "Hunzaker",
      :created_at    => Time.now,
      :updated_at    => Time.now
    )
end

#######################################################
# 2) Controllers
#######################################################

get '/login' do
    erb :"../../personas/tools/authentication/views/login", :layout => :"../../personas/tools/authentication/views/layout.html"
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
    User.get(session[:current_user])
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
        return_or_redirect_to '/admin'
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