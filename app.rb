# Required Gems
require 'rubygems'
require "bundler/setup"

require 'sinatra'
require 'sinatra/flash'
require 'erb'

require 'maruku'

# Database connections
require './db/db_config.rb'

enable :sessions

# Routes
get '/' do
    erb :'index.html'
end

# Manage Pages
get '/page/:id' do 

    @page = Page.get(params[:id])
    @content = Maruku.new("#{@page.body}").to_html
    
    erb :"page.html"
end

get "/new" do 
    erb :"manage/new.html"
end

get "/edit/:id" do
    @page = Page.get(params[:id])
    
    erb :"manage/edit.html"
end

get "/destroy/:id" do 

    Page.get(params[:id]).destroy
    
    flash[:notice] = "Post was successfully destroyed."
    
    redirect "/"

end


post "/create" do 
    
    Page.create(
      :title      => "#{params[:title]}",
      :body       => "#{params[:body]}",
      :created_at => Time.now
    )
    
    flash[:success] = "Post was successfully made!"
    
    redirect "/page/#{Page.last.id}"

end

post "/update/:id" do 

    @page = Page.get(params[:id])

    @page.update(
      :title      => "#{params[:title]}",
      :body       => "#{params[:body]}",
    )
    
    flash[:success] = "Post was successfully updated."
    
    redirect "/page/#{@page.id}"

end


# Tools

get '/tools/type' do    
    erb :'tools/type.html'
end