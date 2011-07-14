#######################################################
# CMS Helper Methods
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
    erb :'../../personas/cms/views/cheatsheet'
  end
  
  
  # Renders the footer template found in the ./views/furniture directory
  #
  # Returns an action to render the footer template
  def get_footer()
    
    output = proto_genesis 'footer'
    output += proto_genesis '../../personas/cms/views/admin' if authorized?
    
    return output
    
  end
    
  
  # Renders the admin menu found in the ./views/furniture directory
  #
  # Returns an action to render the admin menu template
  def get_admin()
    proto_genesis '../../personas/cms/views/admin'
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