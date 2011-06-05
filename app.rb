# Required Gems

['rubygems', 'bundler/setup', 'sinatra', 'sinatra/flash', 'erb', 'maruku'].each do |f|
    require f
end

enable :sessions

# Models
require './proto-includes/db/db_config.rb'

# Helpers
require './proto-includes/helpers.rb'

# Root
get '/' do
    erb :'templates/blog'
end

# General Pages
get 'pages/:name' do
    erb :"pages/#{params[:name]}"
end 

# Manage Prototypical Content
get '/node/:id' do 
    @content = Content.get(params[:id])
    
    erb :single
end

get "/new" do 
    erb :"manage/new"
end

get "/edit/:id" do
    @content = Content.get(params[:id])
    
    erb :"manage/edit"
end

get "/destroy/:id" do 

    Content.get(params[:id]).destroy
    
    flash[:alert] = "Content was destroyed."
    
    redirect "/"

end

post "/create" do 
    
        content = Content.new(
          :title            => "#{params[:title]}",
          :body             => "#{params[:body]}",
          :created_at       => Time.now,
          :content_type     => :"#{params[:content_type]}"
        )
        
        if content.save
          flash[:success] = "#{params[:content_type].capitalize} was created!"
          redirect "/node/#{content.id}"
        else
          content.errors.each do |e|
            flash[:error] = e
          end
            redirect back
        end
            
end

post "/update/:id" do 

    @content = Content.get(params[:id])

    @content.update(
      :title      => "#{params[:title]}",
      :body       => "#{params[:body]}"
    )
    
    flash[:info] = "#{@content.content_type.capitalize} was successfully updated."
    
    redirect "/node/#{@content.id}"

end

# Tools
get '/tools/:name' do    
    erb :"tools/#{params[:name]}"
end

# JavaScripts/CoffeeScripts
get '/javascripts/:name' do
    
    if ENV['RACK_ENV'] == 'development'
        require 'rake'
        Rake::Task["js:compile"]
        
        File.read("public/javascripts/#{params[:name]}.js")
    else
        File.read("public/javascripts/#{params[:name]}.js")
    end
end
