#######################################################
#                 CMS Controller                      #
#######################################################
#                                                     #
#######################################################
#                 Table of Contents                   #
#######################################################
#                                                     #
# 1) Basic Routes                                     #
# 2) Admin Routes                                     #
#                                                     #
#######################################################

module Persona
  
  # Extend the Frontman with new routes and helpers
  class Frontman < Persona::Base      
  
    # Map out our routes for content
    get '/' do
      @content = Content.get(System.homepage) || Content.first
      erb :index, :views => "themes/#{System.theme}"
    end
    
    get '/content/:id' do
      erb :"templates/#{Content.get(params[:id]).template}", :views => "themes/#{System.theme}"
    end
        
  end
  
  class Composer < Persona::Base
    
    # Change the default directories to point to "themes"
    set :views,  Proc.new  { File.join("#{File.dirname(__FILE__)}", "views") }
    set :layout, Proc.new  { File.join("#{File.dirname(__FILE__)}", "views") }
      
             
    #######################################################
    #  2) Admin Content Routes
    #######################################################        
      
      # Create
      #########################################
      
      get "/create" do
        require_user
        erb :new
      end
      
      post '/create' do
        require_user
        
        @record = Content.new(params[:record])
              
        if @record.save
          flash[:success] = "<strong>Content</strong> was successfully created. <a href='/content/#{@record.id}'>Visit page</a>"
          redirect "/admin/content"
        else
          errors = ""
          
          @record.errors.each do |e|
            errors += e.first + "<br/>"
          end
          
          # Display Errors
          flash.now[:error] = "<strong>Error#{"s" if @record.errors.count > 1}:</strong><br/>#{errors}"
          
          # Go back, only maintain old values
          erb :new, :locals => { :"@record" => @record }
        end
      end

      # Read
      #########################################
        
        get "/" do
          require_user
          erb :manage
        end
      
      # Update
      #########################################

        get '/edit/:id' do 
          require_user
          erb :edit
        end
      
        post '/edit/:id' do
          require_user
          
          @record = Content.get(params[:id])
          
          if @record.update(params[:record])
            flash[:success] = "<strong>Content</strong> was successfully updated. <a href='/content/#{@record.id}'>Visit page</a>"
            redirect "/admin/content"
          else
            errors = ""
            
            @record.errors.each do |e|
              errors += e.first + "<br/>"
            end
            flash[:error] = "<strong>Error#{"s" if @record.errors.count > 1}:</strong><br/>#{errors}"
            redirect "/admin/content/edit/#{params[:id]}"
          end
                
        end
      
      #  d. Delete Routes
      #########################################
        
        get '/delete/:id' do
          @record = Content.get(params[:id])
    
          @record.destroy
          
          flash[:notice] = "<strong>#{humanize @record.content_type}</strong> was successfully deleted"
          
          redirect "/admin/content"
          
        end
        
  end
end