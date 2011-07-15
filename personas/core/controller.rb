#########################################
#           Core Controller             #
#########################################
#                                       #
#  1. General Routes                    #
#  2. CRUD                              #
#       a) Create Routes                #
#       b) Read Routes                  #
#       c) Update Routes                #
#       d) Delete Routes                #
#                                       #
#########################################

#########################################
#  2. General Routes
#########################################
  
  # Load all stylesheets through Compass
  get '/stylesheets/:name.css' do
    content_type 'text/css', :charset => 'utf-8'
    scss(:"stylesheets/#{params[:name]}", Compass.sass_engine_options )
  end
  
  # Load admin styles through Compass
  get "/admin/stylesheets/:name.css" do
    content_type 'text/css', :charset => 'utf-8'
    scss(:"../../personas/core/views/stylesheets/#{params[:name]}", Compass.sass_engine_options )
  end
  
  # Handle javascript and coffeescript
  get "/admin/javascripts/:name.js" do
      content_type 'text/javascript'
      coffee :"../../personas/core/views/javascripts/#{params[:name]}"
  end
  
  get '/' do
    erb :index
  end
  
  get '/admin' do
    require_user
    erb :"../../personas/core/views/index", :layout => :"../../personas/core/views/layout.html"
  end
  
  get '/admin/system' do
    require_user
    erb :"../../personas/core/views/system", :layout => :"../../personas/core/views/layout.html"
  end
  
  post '/admin/system' do
    _theme = System.theme
    
    System.first.update(params[:'system'])
    
    require "./themes/#{System.theme}/config.rb"
    
    flash[:success] = "<strong>System</strong> was successfully updated"

    redirect "/admin"
    
  end
  
  
#########################################
#  2. CRUD
#########################################
  
  #########################################
  #  a. Create Routes
  #########################################
      
    get '/admin/manage/create/:name' do
      require_user
      @model = DataMapper::Model.descendants.find{ |model| model.name.downcase == params[:name]}
      @record = @model.new(params[:record])
      
      erb :"../../personas/core/views/new", :layout => :"../../personas/core/views/layout.html"
    end
    
    post '/admin/manage/create/:name' do
      require_user
      
      @model = DataMapper::Model.descendants.find{ |model| model.name.downcase == params[:name]}      
      @record = @model.new(params[:record])
            
      if @record.save
        flash[:success] = "<strong>#{@model.name.capitalize}</strong> was successfully created."
        redirect "/admin/manage/#{@model.name.downcase}"
      else
        errors = ""
        
        @record.errors.each do |e|
          errors += e.first + "<br/>"
        end
        
        # Display Errors
        flash.now[:error] = "<strong>Error#{"s" if @record.errors.count > 1}:</strong><br/>#{errors}"
        
        # Go back, only maintain old values
        erb :"../../personas/core/views/new", :layout => :"../../personas/core/views/layout.html", :locals => { :"@record" => @record }
      end
    end
      
      
  #########################################
  #  b. Read Routes
  ######################################### 
    
    get '/admin/manage/:name' do
      require_user
      @model = DataMapper::Model.descendants.find{ |model| model.name.downcase == params[:name]}
      erb :"../../personas/core/views/manage", :layout => :"../../personas/core/views/layout.html"
    end
    
    
  #########################################
  #  c. Update Routes
  #########################################

    get '/admin/manage/:name/edit/:id' do
      require_user
      @model = DataMapper::Model.descendants.find{ |model| model.name.downcase == params[:name]}
      @record = @model.get(params[:id])
      
      erb :"../../personas/core/views/edit", :layout => :"../../personas/core/views/layout.html"
    end
      
    post '/admin/manage/:name/edit/:id' do
      require_user
      @model = DataMapper::Model.descendants.find{ |model| model.name.downcase == params[:name]}
      @record = @model.get(params[:id])
      
      if @record.update(params[:record])
        flash[:success] = "<strong>#{@model.name.capitalize}</strong> was successfully updated"
        redirect "/admin/manage/#{@model.name.downcase}"
      else
        errors = ""
        
        @record.errors.each do |e|
          errors += e.first + "<br/>"
        end
        flash[:error] = "<strong>Error#{"s" if @record.errors.count > 1}:</strong><br/>#{errors}"
        redirect "/admin/manage/#{params[:name]}/edit/#{params[:id]}"
      end
            
    end
      
      
  #########################################
  #  d. Delete Routes
  #########################################
    
    get '/admin/manage/delete/:name/:id' do
      require_user
      @model = DataMapper::Model.descendants.find{ |model| model.name.downcase == params[:name]}      
      @record = @model.get(params[:id])

      @record.destroy
      
      flash[:error] = "<strong>#{@model.name}</strong> was successfully deleted"
      
      redirect "/admin/manage/#{@model.name.downcase}"
    end
  