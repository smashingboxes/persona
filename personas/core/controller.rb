#########################################
#           Core Controller             #
#########################################
#                                       #
#  1. Directory Filters                 #
#                                       #
#  2. Resource Routes                   #
#       a) JavaScript                   #
#                                       #
#  3. General Routes                    #
#                                       #
#  4. General CRUD                      #
#       a) Create Routes                #
#       b) Read Routes                  #
#       c) Update Routes                #
#       d) Delete Routes                #
#                                       #
#########################################


#########################################
#  1. Directories
#########################################    
  
  # Change the default directories to point to "themes"
  set :views,  Proc.new  { File.join(root, "/themes/#{System.theme}") }
  set :public, Proc.new  { File.join(root, "/themes/#{System.theme}") } 
  set :layout, Proc.new  { File.join(root, "/themes/#{System.theme}") }
              
    
#########################################
#  2. Resource Routes
#########################################
          
  # a. JavaScript (and CoffeeScript)
  #########################################
      
      # Handle javascript and coffeescript
      get "/admin/javascripts/:name.js" do
          content_type 'text/javascript'
          coffee :"/javascripts/#{params[:name]}"
      end
  
  # b. Stylesheets
  #########################################
      
      # Handle general styles
      get '/stylesheets/:name' do
          content_type 'text/css'
                
          File.read("themes/#{System.theme}/stylesheets/#{params[:name]}")
      end
      
      # Handle admin styles
      get '/admin/stylesheets/:name.css' do
          content_type 'text/css'
          
          File.read("personas/core/views/stylesheets/#{params[:name]}.css")
      end

#########################################
#  2. General Routes
#########################################
    
  # Route Directory
  get '/?' do
    erb :index
  end
  
  get '/admin/require/:name' do
    @model = DataMapper::Model.descendants.find{|m| m.name.to_s.downcase == params[:name].to_s}
    admin :requirements, :safety
  end
  
  # The Admin Console
  get '/admin/?' do
    admin :index
  end
  
  # System Settings (A custom template)
  get '/admin/system' do
    admin :system
  end
  
  # Update System Settings
  post '/admin/system' do
    _theme = System.theme
    
    System.first.update(params[:'system'])
    
    require "./themes/#{System.theme}/config.rb"
    
    DataMapper::Model.descendants.each do |model|
      DataMapper.finalize
      model.auto_upgrade!
    end
    
    flash[:success] = "<strong>System</strong> was successfully updated"
  
    redirect "/admin"
  end
  
  # Admin Tools
  get "/admin/tools" do
    erb :"../../personas/tools/index", :layout => :"../../personas/core/views/layout"
  end
    
  
#########################################
#  2. General CRUD
#########################################
  
  #########################################
  #  a. Create Routes
  #########################################
      
    get '/admin/:name/create' do    
        @model = DataMapper::Model.descendants.find{ |model| model.name.downcase == params[:name]}
        @record = @model.new(params[:record])
        
        admin :new
    end
    
    post '/admin/:name/create' do
      
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
        erb :'../../personas/core/views/new', :layout => :'../../personas/core/views/layout', :locals => { :"@record" => @record }
      end
    end
      
      
  #########################################
  #  b. Read Routes
  ######################################### 
    
    core_read = get '/admin/:name' do
      erb :'../../personas/core/views/manage', :layout => :'../../personas/core/views/layout', :locals => {:"@model" => DataMapper::Model.descendants.find{ |model| model.name.downcase == params[:name]} }
    end
    
    
  #########################################
  #  c. Update Routes
  #########################################

    get '/admin/:name/edit/:id' do
      @model = DataMapper::Model.descendants.find{ |model| model.name.downcase == params[:name]}
      @record = @model.get(params[:id])
      
      admin :edit
    end
      
    post '/admin/:name/edit/:id' do
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
        redirect "/admin/#{params[:name]}/edit/#{params[:id]}"
      end
            
    end
      
      
  #########################################
  #  d. Delete Routes
  #########################################
    
    post '/admin/:name/:id' do
      @model = DataMapper::Model.descendants.find{ |model| model.name.downcase == params[:name]}      
      @record = @model.get(params[:id])

      @record.destroy
      
      flash[:error] = "<strong>#{@model.name}</strong> was successfully deleted"
      
      redirect "/admin/manage/#{@model.name.downcase}"
    end
  