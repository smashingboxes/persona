#######################################################
#                    CMS Persona                      #
#######################################################
#                                                     #
#######################################################
#                 Table of Contents                   #
#######################################################
#                                                     #
# 1) Model                                            #
# 2) Controller                                       #
#    a) Basic Content CRUD                            #
#    b) Administration Panel                          #
# 3) Helper Methods                                   #
#    a) General Helper Methods                        #
#    b) Protoloop Methods                             #
#       i) the author                                 #
#      ii) the_content                                #
#     iii) the_content_type                           #
#      iv) the_datetime                               #
#      vi) the_excerpt                                #
#     vii) the_id                                     #
#    viii) the_link                                   #
#      ix) the_parent                                 #
#       x) the_title                                  #
#      xi) the_template                               #
#                                                     #
#######################################################

load_persona "tools/authentication"

#######################################################
# 1) Model
#######################################################

  class Content
    include DataMapper::Resource
  
    property :id,                 Serial
    property :title,              String,                                                      :required => true,      :message => "Please specify a title for this content."
    property :body,               Text

    property :content_type,       Enum[:post, :page, :category, :comment, :tag, :widget],      :required => true,      :message => "Please specify the content type."
    property :parent,             Integer,                                                     :default  => 0
    property :template,           String,                                                      :default  => "single"
    property :author,             Integer,                                                     :default => User.first.id
    
    property :created_at,         DateTime
    property :updated_at,         DateTime 
    
    # Allows to use the content_type as a class method, e.g., Content.post, Content.page
    # Todo: Add an singularize method and use the plural form of content_type as method name.
    def self.method_missing(name, *args)
      self.all(:content_type => name.to_s)
    end
    
  end

  # Creates a datatable with the current website settings
  class System
    include DataMapper::Resource
    
    property :id,              Serial
    property :theme ,          String,       :required => true,      :message => "Please specify a theme for this site.",      :default => "protoplasm"
    property :title,           String,       :required => true,      :message => "Please specify a title for this site",       :default => "Prototypical"
    property :description,     String,       :required => false,     :default => "A basic CMS"
    property :homepage,        Integer,      :required => true,      :default  => 0
  
    def self.theme
      self.first.theme
    end
    
    def self.title
      self.first.title
    end
    
    def self.description
      self.first.description
    end
    
    def self.homepage
      self.first.homepage
    end 
    
  end
        
  DataMapper.finalize
  DataMapper.auto_upgrade!

    
  # Create the default settings
  unless Content.first
    @homepage = Content.create(
      :title => "Hello, world!",
      :content_type => "page"
      )
  end
  
  # Create the default settings
  @system = System.create(
      :homepage => Content.first.id
  )
  

#######################################################
# 2) Controller
#######################################################

# Change the default directories to point to "themes"
set :views, Proc.new { File.join(root, "/themes/#{System.theme}/") }
set :public, Proc.new { File.join(root, "/themes/#{System.theme}/") }

module Templates
  @default_layout = :"../../proto-includes/personas/cms/admin/layout"
end

# Look for a base layout file to work with
get '/' do
  @content = Content.get(System.homepage) || Content.first
  proto_genesis 'index'
end

get '/node/:id' do
  proto_genesis "/templates/#{Content.get(params[:id]).template}"
end

get '/node/:id' do     
  proto_genesis "/#{Content.get(params[:id]).template}"
end

get "/new" do
  require_user
  erb :"../../proto-includes/personas/cms/admin/new", {:layout => :"../../proto-includes/personas/cms/admin/layout"}
end

  
  #####################################################
  # a) Basic Content CRUD
  #####################################################


  get "/edit/:id" do
      require_user
      erb :"../../proto-includes/personas/cms/admin/edit", {:layout => :'../../proto-includes/personas/cms/admin/layout'}
  end
  
  
  get "/destroy/:id" do 
      
      require_user
      
      Content.get(params[:id]).destroy
      flash[:alert] = "Content was destroyed."
      redirect "/"
  
  end
  
  
  post "/create" do 
      
      require_user
      
      content = Content.new(
        :title            => params[:title],
        :body             => params[:body],
        :content_type     => params[:content_type],
        :template         => params[:template],
        :parent           => params[:parent],
        :author           => current_user,
        :created_at       => Time.now,
        :updated_at       => Time.now
      )
      
      if content.save
        flash[:success] = "#{params[:content_type].capitalize} was created!"
        redirect "/node/#{content.id}"
      else
        content.errors.each do |e|
          flash[:error] = "The following errors occured: #{e}"
        end
          redirect back
      end
  
  end
  
  
  post "/update/:id" do 
      
      require_user
      
      @target = Content.get(params[:id])
  
      @target.update(
        :title        => params[:title],
        :body         => params[:body],
        :template     => params[:template],
        :updated_at   => Time.now
      )
      
      flash[:info] = "Content was successfully updated!"
      
      redirect "/node/#{@target.id}"
  
  end
  
  #####################################################
  # b) Administration Panel
  #####################################################

  get "/admin" do
    require_user
    
    erb :"../../proto-includes/personas/cms/admin/system", {:layout => :"../../proto-includes/personas/cms/admin/layout"}
  end
  
  get "/admin/stylesheets/:name" do
      File.read("proto-includes/personas/cms/admin/#{params[:name]}")
  end
  
  post "/admin" do 
  
    @system = System.first
  
    @system.update(
      :title        => params[:title],
      :theme        => params[:theme],
      :description  => params[:description],
      :homepage     => params[:homepage]
    )
    
    flash[:info] = "System was successfully updated!"
    
    redirect "/"
    
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
  
    source = "./themes/#{current_theme}/templates/"
    
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
    proto_genesis 'header'
  end
  
  
  # Renders the sidebar template found in the ./views/furniture directory
  #
  # css_class => Helps to dictate the styling of the sidebar by inserting a class
  #
  # Returns an action to render the sidebar template
  def get_sidebar(css_class="left")
    @css_class = css_class
    proto_genesis 'sidebar'
  end
  
  
  # Renders the cheatsheat template found in the ./proto-includes/personas/cms/admin
  #
  # Returns an action to render the cheatsheet template
  def get_cheatsheet()
    erb :'../../proto-includes/personas/cms/admin/cheatsheet'
  end
  
  
  # Renders the footer template found in the ./views/furniture directory
  #
  # Returns an action to render the footer template
  def get_footer()
    
    output = proto_genesis 'footer'
    output += proto_genesis '../../proto-includes/personas/cms/admin/admin' if authorized?
    
    return output
    
  end
    
  
  # Renders the admin menu found in the ./views/furniture directory
  #
  # Returns an action to render the admin menu template
  def get_admin()
    proto_genesis '../../proto-includes/personas/cms/admin/admin'
  end
  
  
  # Renders a navigation bar
  #
  # options => Optional overides to dicate the output of the nav
  #            html element.
  #
  # Example:
  #   get_navigation({ :css_class => "menu" })
  #       # => <nav class="menu">
  #               <ul>
  #                   <li><a href="/node/1">Title</a></li> ...
  #               </ul>
  #            </nav>
  #
  # Returns a string describing the navigation HTML component
  def get_navigation( options={} )
    
    local_options = {
        :css_class    => options[:css_class] || "menu",
        :include_home => options[:include_home] || false    
    }
    
    @css_class = local_options[:css_class]
    @include_home = local_options[:css_class]
    
    def get_position(index, content)
        
        list_style = ""
        
        # Get position
        if index == 0
            list_style += "first"
        elsif index == Content.pages.size - 1
            list_style += "last"
        end
        
        # Is this the current link?
        if (content.id == params[:id].to_i)
          list_style += " current"
        end

    end
    
    proto_genesis "navigation"
        
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
  
  
  # Finds the author of a given content entry in the database
  #
  # content => An optional overide to display the author of a specific
  #            content item.
  #
  # Retuns the author of the passed object (Be it from the protoloop or argument)
  def the_author(content=nil)
    if node = content || @content || Content.get(params[:id])
        
      author = User.get(node.author)
        
      if (author.first_name && author.second_name)
        ( User.get(node.author).first_name + " " + User.get(node.author).last_name )
      else          
        author.username
      end
        
    else
      "<strong>Error:</strong> No author could be found" unless ENV['RACK_ENV'] == 'production'
    end
  end
  
  
  # Finds the content of a given content entry in the database
  #
  # content => An optional overide to display the content of a specific
  #            content item.
  # raw     => A boolean which tells the function to spit out the unformated 
  #            data (true) or format it using Markdown (false)
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

  
  # Finds the name of the template for a given content entry in the database
  #
  # Content => An optional argument to dictate the content in question
  #
  # Returns the name of of the passed content object
  def the_content_type(content=nil)
    if node = content || @content || Content.get(params[:id])
      node.content_type
    else
      "<strong>Error:</strong> No content type information could be found" unless ENV['RACK_ENV'] == 'production'
    end
  end
  
  
  # Finds the datetime of a given content entry in the database
  #
  # content => An optional overide to display the datetime of a specific
  #            content item.
  # output  => An optional overide to specify a format for the returned datetime
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
  # and truncates it to 100 words.
  #
  # content => An optional overide to display the truncated body copy
  #            of a specific content item.
  # length  => A number value dictating the maximum word count of the 
  #            returned content (defaults to 100 words)
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
  # Content => An optional argument to dictate the content in question
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
  # Content => An optional argument to dictate the content in question
  # 
  # Returns the ID of the passed content object
  def the_id(content=nil)
    if node = content || @content || Content.get(params[:id])
      node.id
    else
      "<strong>Error:</strong> No content identifier could be found" unless ENV['RACK_ENV'] == 'production'
    end
  end
  
  
  # Finds the parent of a given piece of content
  #
  # Content => An optional argument to dictate the content in question
  #
  # Returns the name of of the passed content object
  def the_parent(content=nil)
    if node = content || @content || Content.get(params[:id])
      node.parent
    else
      "<strong>Error:</strong> No parent information could be found" unless ENV['RACK_ENV'] == 'production'
    end
  end
  
  
  # Finds the name of the template for a given content entry in the database
  #
  # Content => An optional argument to dictate the content in question
  #
  # Returns the name of of the passed content object
  def the_template(content=nil)
    if node = content || @content || Content.get(params[:id])
      node.template
    else
      "<strong>Error:</strong> No template information could be found" unless ENV['RACK_ENV'] == 'production'
    end
  end
  
  
  # Finds the title of a given content entry in the database
  #
  # content => An optional overide to display the title of a specific
  #            content item.
  #
  # Retuns the title of the passed object (Be it from the protoloop or argument)
  def the_title(content=nil)
    if node = content || @content || Content.get(params[:id])
      node.title
    else
      "<strong>Error:</strong> No title could be found" unless ENV['RACK_ENV'] == 'production'
    end
  end  
  
  
  # Determines if a piece of content has children
  #
  # type => The type of child content to look for
  #
  # Returns a boolean
  def has_children?(type="page", content=nil)
    node = content || @content || Content.get(params[:id]) || nil
    
    if ( node && Content.all(:parent => node.id, :content_type => type).count > 0 )
        return true
    else
        return false
    end      
  end    
    
  
  # At last, the magic. A yield loop that finds every instance of a specific content type
  #
  # Type  => Specifies the type of content to run through
  #          the proto_loop.
  # Count => Specifies how many items to include in the
  #          loop.
  #
  def proto_loop(type="post", count=nil)

    # Get content type
    # For everything but pages, we want to reverse the order
    # so that the most recent content displays first.
    aggregator = Content.all(:content_type => type)
    aggregator.reverse! unless type == "page"
    
    # Limit the aggregator to the desired content count
    aggregator = aggregator[0..(count-1)] unless count.nil?
    
    # We don't know if the content is set to anything, so we'll set it up here first
    @old_content = @content || nil
        
    # Run through each item the aggregator finds
    aggregator.each_with_index do |node, index|

      @index = index
      @content = node
      
      yield
        
    end
    
    # Reset the content back to normal
    @content = @old_content || nil
    
  end
  
  
  # Finds all children of a given content entry in the database
  #
  # type    => Specifies the type of content to run through
  #            the child_loop.
  # content => An optional overide to display the title of a specific
  #            content item.
  # count   => Specifies how many items to include in the
  #            loop.
  #
  def child_loop(type="comment", content=nil, count=nil)
    
    # Check for parent
    parent = content || @content || Content.get(params[:id]) || nil
    return [] if parent == nil
    
    # Check to see if the piece of content even has children
    # if not, return an empty array
    aggregator = Content.all(:content_type => type, :parent => parent.id)
    return [] if aggregator.count == 0
    
    # For everything but pages, we want to reverse the order
    # so that the most recent content displays first.
    aggregator.reverse! unless type == "page"
    
    # Limit the aggregator to the desired content count
    aggregator = aggregator[0..(count-1)] unless count.nil?
    
    # We don't know if the content is set to anything, so we'll set it up here first
    @old_content = @content || nil
        
    # Run through each item the aggregator finds
    aggregator.each_with_index do |node, index|

      @index = index
      @content = node
      
      yield
        
    end
    
    # Reset the content back to normal
    @content = @old_content || nil
    
  end

end