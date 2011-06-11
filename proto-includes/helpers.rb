helpers do

###########################
#    Table of Contents    #
###########################
#
# 1) General Template Helper Methods
# 2) Protoloop Methods (the_content, the_title, etc...)
#
###########################
    
###########################
# 1) General Template Helper Methods
###########################
    
    
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

    
###########################
# 2) Protoloop Methods (the_content, the_title, etc...)
###########################
    #
    # NOTES:
    #
    # All attribute finders will seek a value in the following order:
    # 1) A passed argument
    # 2) An object variable within the proto_loop()
    # 3) The current query string
    # 4) Return nil (throw error)
    
    
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
            flash[:error] = "<strong>Error:</strong> No title could be found" unless ENV['RACK_ENV'] == 'production'
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
            flash[:error] = "<strong>Error:</strong> No creation date could be found" unless ENV['RACK_ENV'] == 'production'
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
            flash[:error] = "<strong>Error:</strong> No content could be found" unless ENV['RACK_ENV'] == 'production'
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
    # @param [Object] a content object overide to the default functionality
    # @return a url to location of the passed content object
    def the_link(content=nil)
        if node = content || @content || Content.get(params[:id])
            "/node/#{node.id}"
        else
            "<strong>Error:</strong> No link could be found" unless ENV['RACK_ENV'] == 'production'
        end
    end
    
    # Finds the primary key of a given content entry in the database.
    #
    # Content - An optional arugment to dictate the content in question
    # Return the ID of the passed content object
    #
    def the_id(content=nil)
        if node = content || @content || Content.get(params[:id])
            node.id
        else
            "<strong>Error:</strong> No content identifier could be found" unless ENV['RACK_ENV'] == 'production'
        end
    end
    
    # Finds the name of the template for a given content entry in the database
    #
    # @param [Object] a content object overide to the default functionality
    # @return The name of of the passed content object
    def the_template(content=nil)
        if node = content || @content || Content.get(params[:id])
            node.template
        else
            "<strong>Error:</strong> No template information could be found" unless ENV['RACK_ENV'] == 'production'
        end
    end

    # At last, the magic:
    def proto_loop(type="post")
        
        # Get content type
        nodes = Content.all(:content_type => type)
                        
        nodes.each do |node|
        
            @content = node
            
            yield
            
        end
        
    end

end