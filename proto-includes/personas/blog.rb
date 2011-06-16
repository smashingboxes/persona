#######################################################
#                 Table of Contents                   #
#######################################################
#                                                     #
# 1) Model                                            #
# 2) Controller                                       #
# 3) Helper Methods                                   #
#    a) General Helper Methods                        #
#    b) Protoloop Methods                             #
#                                                     #
#######################################################


#######################################################
# 1) Model
#######################################################

  class Content
    include DataMapper::Resource
  
    property :id,                 Serial
    property :title,              String,                                             :required => true,      :message => "Please specify a title for this page."
    property :body,               Text
    property :content_type,       Enum[:post, :page, :category, :comment, :tag],      :required => true,      :message => "Please specify the content type."
    property :parent,             Integer,                                            :default => 0
    property :template,           String,                                             :default => "single"
    
    property :created_at,         DateTime
    property :updated_at,         DateTime 
    
    def self.posts
      self.all(:content_type => "post")
    end
  
    def self.pages
      self.all(:content_type => "page")
    end
    
    def self.categories
      self.all(:content_type => "category")
    end
    
    def self.comments
      self.all(:content_type => "comment")
    end
    
    def self.pages
      self.all(:content_type => "tag")
    end
    
  end
  
  DataMapper.finalize
  DataMapper.auto_upgrade!


#######################################################
# 2) Controller
#######################################################

get '/node/:id' do     
    erb :"templates/#{Content.get(params[:id]).template}"
end

get "/new" do 
    erb :"manage/new"
end

get "/edit/:id" do    
    erb :"manage/edit"
end

get "/destroy/:id" do 

    Content.get(params[:id]).destroy
    
    flash[:alert] = "Content was destroyed."
    
    redirect "/"

end

post "/create" do 
    
    content = Content.new(
      :title            => params[:title],
      :body             => params[:body],
      :content_type     => params[:content_type],
      :template         => params[:template],
      :parent           => params[:parent],
      :created_at       => Time.now,
      :updated_at       => Time.now
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
      :title        => params[:title],
      :body         => params[:body],
      :template     => params[:template],
      :updated_at   => Time.now
    )
    
    flash[:info] = "Content was successfully updated!"
    
    redirect "/node/#{@content.id}"

end



#######################################################
# 3) Helper Methods
#######################################################

helpers do
 
  #####################################################
  # a) General Helper Methods
  #####################################################
    
  # Scans for all .erb files in the ./views/templates directory 
  #
  # Return an array of strings equal to template names
  def templates()
    source = "./views/templates/"
    
    cluster = []
    
    Dir.foreach(source) do |cf|
      unless cf == '.' || cf == '..' 
        cluster << cf.split('.').first
      end 
    end
    
    return cluster
  end
  
  # Renders the header template found in the ./views/furniture directory
  #
  # Returns an action to render the header template
  def get_header()
    erb :'furniture/header'
  end
  
  # Renders the sidebar template found in the ./views/furniture directory
  #
  # css_class - Helps to dictate the styling of the sidebar by inserting a class
  #
  # Returns an action to render the sidebar template
  def get_sidebar(css_class="left")
    @css_class = css_class
    erb :'furniture/sidebar'
  end
  
  # Renders the footer template found in the ./views/furniture directory
  #
  # Returns an action to render the footer template
  def get_footer()
    erb :'furniture/footer'
  end
  
  # Renders the admin menu found in the ./views/furniture directory
  #
  # Returns an action to render the admin menu template
  def get_admin()
    erb :'furniture/admin'
  end
  
  # Renders a link tag with stylesheet information
  #
  # stylesheet - The name of the stylesheet. Defaults to 'screen'
  # media      - The media format the stylesheet will be displayed as.
  #              Defaults to 'screen'
  #
  # Example:
  #   get_stylesheet("print", "print")
  #       # => <link rel='stylesheet' href='/stylesheets/print.css' media='print'/>
  #
  # Returns an action to render the admin menu template
  def get_stylesheet(stylesheet="screen", media="screen")
    return "<link rel='stylesheet' href='/stylesheets/#{stylesheet}.css' media='#{media}'/>"  
  end
  
  # Renders a navigation bar
  #
  # css_class - An optional overide to dicate the class of the nav
  #             html element. Defaults to "menu"
  #
  # Example:
  #   get_navigation("menu")
  #       # => <nav class="menu">
  #               <ul>
  #                   <li><a href="/node/1">Title</a></li> ...
  #               </ul>
  #            </nav>
  #
  # Returns a string describing the navigation HTML component
  def get_navigation(css_class="menu")
    nav = ""
    
    nav += "<nav class='#{css_class}'>"
    nav += "<ul>"
    
    Content.all(:content_type => "page").each do |p|
      if p.parent == 0
        nav = nav + "<li><a href='/node/#{p.id}'>#{p.title}</a></li>"
      end                    
    end
    
    nav += "</ul>"
    nav += "</nav>"
    
    return nav
  end
  

  #######################################################
  # b) Protoloop Methods (the_content, the_title, etc...)
  #######################################################
  #
  # NOTES:
  #
  # All attribute finders will seek a value in the following order:
  # 1) A passed argument
  # 2) An object variable within the proto_loop()
  # 3) The current query string
  # 4) Throw exception (a template friendly error)
  
  
  # Finds the title of a given content entry in the database
  #
  # content - An optional overide to display the title of a specific
  #           content item.
  #
  # Retuns the title of the passed object (Be it from the protoloop or argument)
  def the_title(content=nil)
    if node = content || @content || Content.get(params[:id])
      node.title
    else
      "<strong>Error:</strong> No title could be found" unless ENV['RACK_ENV'] == 'production'
    end
  end
  
  # Finds the datetime of a given content entry in the database
  #
  # content - An optional overide to display the datetime of a specific
  #           content item.
  # output  - An optional overide to specify a format for the returned datetime
  #
  # Retuns the datetime of the passed object (Be it from the protoloop or argument)
  def the_datetime(content=nil, output=nil)
    if node = content || @content || Content.get(params[:id])
      output.nil? ? node.created_at : node.created_at.strftime(output)
    else
      "<strong>Error:</strong> No creation date could be found" unless ENV['RACK_ENV'] == 'production'
    end
  end
  
  # Finds the content of a given content entry in the database
  #
  # content - An optional overide to display the content of a specific
  #           content item.
  # raw     - A boolean which tells the function to spit out the unformated 
  #           data (true) or format it using Markdown (false)
  #
  # Returns the content of the passed object
  def the_content(content=nil, raw=false)    
     
    if node = content || @content || Content.get(params[:id])
      
      # Show raw markdown, or html translation
      raw ? node.body :  Maruku.new("#{node.body}").to_html

    else
      "<strong>Error:</strong> No content could be found" unless ENV['RACK_ENV'] == 'production'
    end
      
  end
  
  # Finds the content of a given content entry in the database
  # and truncates it to 100 words.
  #
  # content - An optional overide to display the truncated body copy
  #           of a specific content item.
  # length  - A number value dictating the maximum word count of the 
  #           returned content (defaults to 100 words)
  #
  # Example:
  #   [assuming content = billy madison is a great movie]   
  #
  #   the_excerpt(content, 2)
  #      # => "billy madison"
  #
  # Returns the truncated content of the passed object
  def the_excerpt(content=nil, length=100)
    if node = content || @content || Content.get(params[:id])
      
      # First, we convert the text to html and strip it
      # (remember it's stored as markdown)
      text = Maruku.new("#{node.body}").to_html.gsub(/<\/?[^>]*>/, "")
      
      # Next, we truncate it
      text = text.split(" ")[0..length].join(" ")
      
      # Add ellipse if anything was actually shortened
      text += "..." unless node.body.split(" ").length < length
      
      return text
        
    else
      "<strong>Error:</strong> No content could be found" unless ENV['RACK_ENV'] == 'production'
    end
  end
  
  # Creates a link to a given content entry in the database
  #
  # Content - An optional argument to dictate the content in question
  # 
  # Returns a url to location of the passed content object
  def the_link(content=nil)
      if node = content || @content || Content.get(params[:id])
        "/node/#{node.id}"
      else
        "<strong>Error:</strong> No link could be found" unless ENV['RACK_ENV'] == 'production'
      end
  end
  
  # Finds the primary key of a given content entry in the database.
  #
  # Content - An optional argument to dictate the content in question
  # 
  # Returns the ID of the passed content object
  def the_id(content=nil)
    if node = content || @content || Content.get(params[:id])
      node.id
    else
      "<strong>Error:</strong> No content identifier could be found" unless ENV['RACK_ENV'] == 'production'
    end
  end
  
  # Finds the name of the template for a given content entry in the database
  #
  # Content - An optional argument to dictate the content in question
  #
  # Returns the name of of the passed content object
  def the_template(content=nil)
    if node = content || @content || Content.get(params[:id])
      node.template
    else
      "<strong>Error:</strong> No template information could be found" unless ENV['RACK_ENV'] == 'production'
    end
  end
  
  # At last, the magic. A yield loop that finds every 
  #
  # Type - Specifies the type of content to run through
  #        the proto_loop.
  #
  def proto_loop(type="post")

    # Get content type
    # For everything but pages, we want to reverse the order
    # so that the most recent content displays first.
    aggregator = Content.all(:content_type => type)
    aggregator.reverse! unless type == "page"
    
    # Run through each item the aggregator finds
    # Unless, of course, their is nothing
    aggregator.each do |node|
    
      @content = node
      
      yield
        
    end 
      
  end
  
end