#########################################
#           Admin Controller            #
#########################################
#                                       #
#########################################

module Persona
  class Administrator < Persona::Base
                        
      # Handle javascript and coffeescript
      get "/javascripts/:name.js" do
          content_type 'text/javascript'
          coffee :"javascripts/#{params[:name]}"
      end
      
      # Handle admin images
      get '/stylesheets/images/:name' do
          File.read("#{here}/personas/administrator/views/stylesheets/images/#{params[:name]}")
      end
          
    
    #  2. General Routes
    #########################################
      
      before "/" do
        require_user unless request.path_info == '/login'
      end
      
      # The Admin Console
      get '/' do
        erb :index
      end
      
      get '/require/:name' do
        @model = DataMapper::Model.descendants.find{|m| m.name.to_s.downcase == params[:name].to_s}
        erb :requirements, :layout => :safety
      end
        
      # System Settings (A custom template)
      get '/system' do
        erb :system
      end
      
      # Update System Settings
      post '/system' do
        _theme = System.theme
        
        System.first.update(params[:'system'])
        
        require "./themes/#{System.theme}/persona.rb"
        
        DataMapper.finalize.auto_upgrade!
        
        flash[:success] = "<strong>System</strong> was successfully updated"
      
        redirect "/"
      end
      
      
    #  2. General CRUD
    #########################################
      
      #  a. Create Routes
      #########################################
          
        get '/:name/create' do    
            @model = DataMapper::Model.descendants.find{ |model| model.name.downcase == params[:name]}
            @record = @model.new(params[:record])
            
            erb :new
        end
        
        post '/:name/create' do
          
          @model = DataMapper::Model.descendants.find{ |model| model.name.downcase == params[:name]}      
          @record = @model.new(params[:record])
                
          if @record.save
            flash[:success] = "<strong>#{@model.name.capitalize}</strong> was successfully created."
            redirect "/admin/#{@model.name.downcase}"
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
          
          
      #  b. Read Routes
      ######################################### 
        
        get '/:name' do
          erb :manage, :locals => {:"@model" => DataMapper::Model.descendants.find{ |model| model.name.downcase == params[:name]} }
        end
        
        
      #  c. Update Routes
      #########################################
    
        get '/:name/edit/:id' do
          @model = DataMapper::Model.descendants.find{ |model| model.name.downcase == params[:name]}
          @record = @model.get(params[:id])
          
          erb :edit
        end
          
        post '/:name/edit/:id' do
          @model = DataMapper::Model.descendants.find{ |model| model.name.downcase == params[:name]}
          @record = @model.get(params[:id])
          
          if @record.update(params[:record])
            flash[:success] = "<strong>#{@model.name.capitalize}</strong> was successfully updated"
            redirect "/admin/#{@model.name.downcase}"
          else
            errors = ""
            
            @record.errors.each do |e|
              errors += e.first + "<br/>"
            end
            flash[:error] = "<strong>Error#{"s" if @record.errors.count > 1}:</strong><br/>#{errors}"
            redirect "/#{params[:name]}/edit/#{params[:id]}"
          end
                
        end
          
          
      #  d. Delete Routes
      #########################################
        
        get '/:name/delete/:id' do
          @model = DataMapper::Model.descendants.find{ |model| model.name.downcase == params[:name]}      
          @record = @model.get(params[:id])
    
          @record.destroy
          
          flash[:error] = "<strong>#{@model.name}</strong> was successfully deleted"
          
          redirect "/admin/#{@model.name.downcase}"
          
        end

  end
end