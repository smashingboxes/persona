#########################################
#           Core Controller             #
#########################################
#                                       #
#  1. Directory Filters                 #
#                                       #
#  2. Resource Routes                   #
#       a) Stylesheets                  #
#       b) JavaScript                   #
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
#  1. Directory Filters
#########################################    
    
    # Ensure there is a user and the correct files are being loaded for the admin
    before do
      
      if request.path =~ /\/admin(\/|\w)*/
          
          require_user
          
          set :views,  Proc.new  { File.join(root, "/personas/core/views") }
          set :public, Proc.new  { File.join(root, "/personas/core/views") }
          set :layout, Proc.new  { File.join(root, "/personas/core/views") }
          
      else
          # Change the default directories to point to "themes"
          set :views,  Proc.new  { File.join(root, "/themes/#{System.theme}") }
          set :public, Proc.new { File.join(root, "/themes/#{System.theme}") } 
          set :layout, Proc.new { File.join(root, "/themes/#{System.theme}") }    
      end
      
    end
    
    
#########################################
#  2. Resource Routes
#########################################
    
  # a. Stylesheets (and SASS/Compass)
  #########################################

      # Load all stylesheets through compass
      get '/stylesheets/:name.css' do
        content_type 'text/css', :charset => 'utf-8'
        scss(:"/stylesheets/#{params[:name]}", Compass.sass_engine_options )
      end
      
      # Force load admin styles
      get '/admin/stylesheets/:name.css' do
        content_type 'text/css', :charset => 'utf-8'
        scss(:"/stylesheets/#{params[:name]}", Compass.sass_engine_options )
      end
      
      
  # b. JavaScript (and CoffeeScript)
  #########################################
      
      # Handle javascript and coffeescript
      get "/admin/javascripts/:name.js" do
          content_type 'text/javascript'
          coffee :"/javascripts/#{params[:name]}"
      end


#########################################
#  2. General Routes
#########################################
  
  # Route Directory
  get '/?' do
    erb :index
  end
  
  get '/admin/require/:name' do
    erb :requirements, :locals => { :'@model' => DataMapper::Model.descendants.find{|m| m.name.to_s.downcase == params[:name].to_s} }, :layout => :safety
  end
  
  # The Admin Console
  get '/admin/?' do
    erb :index
  end
  
  # System Settings (A custom template)
  get '/admin/system' do
    erb :system
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
    erb :"../../../personas/tools/index"
  end
    
  
#########################################
#  2. General CRUD
#########################################
  
  #########################################
  #  a. Create Routes
  #########################################
      
    core_new = get '/admin/:name/create' do    
        @model = DataMapper::Model.descendants.find{ |model| model.name.downcase == params[:name]}
        @record = @model.new(params[:record])
        
        erb :new
    end
    
    core_create = post '/admin/:name/create' do
      
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
      
      
  #########################################
  #  b. Read Routes
  ######################################### 
    
    core_read = get '/admin/:name' do
      erb :manage, :locals => {:"@model" => DataMapper::Model.descendants.find{ |model| model.name.downcase == params[:name]} }
    end
    
    
  #########################################
  #  c. Update Routes
  #########################################

    core_edit = get '/admin/:name/edit/:id' do
      @model = DataMapper::Model.descendants.find{ |model| model.name.downcase == params[:name]}
      @record = @model.get(params[:id])
      
      erb :edit
    end
      
    core_update = post '/admin/:name/edit/:id' do
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
    
    core_delete = post '/admin/:name/:id' do
      @model = DataMapper::Model.descendants.find{ |model| model.name.downcase == params[:name]}      
      @record = @model.get(params[:id])

      @record.destroy
      
      flash[:error] = "<strong>#{@model.name}</strong> was successfully deleted"
      
      redirect "/admin/manage/#{@model.name.downcase}"
    end
  