helpers do

###########################
# Templating
###########################
    
    # Scans for all .erb files in the ./views/templates directory 
    #
    # @param
    # @return [Array] of template name strings
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
    # @param
    # @return An action to render the header template
    def get_header()
        erb :'furniture/header'
    end
    
    # Renders the sidebar template found in the ./views/furniture directory
    #
    # @param [String] Helpts to dictate the styling of the sidebar
    # @return An action to render the sidebar template
    def get_sidebar(css_class="left")
        @css_class = css_class
        erb :'furniture/sidebar'
    end
    
    # Renders the footer template found in the ./views/furniture directory
    #
    # @param
    # @return An action to render the footer template
    def get_footer()
        erb :'furniture/footer'
    end
    
    # Renders the admin menu found in the ./views/furniture directory
    #
    # @param
    # @return An action to render the admin menu template
    def get_admin()
        erb :'furniture/admin'
    end

    
###########################
# The Proto Loop
###########################

    # All attribute finders will seek a value in the following order:
        # 1) A passed argument
        # 2) An object variable within the proto_loop()
        # 3) The current query string
        # 4) Return nil (throw error)
    
    
    # Finds the title of a given content entry in the database
    #
    # @param [Object] a content object overide to the default functionality
    # @return The title of the passed object
    def the_title(content=nil)
        if node = content || @content || Content.get(params[:id])
            node.title
        else
            flash[:error] = "<strong>Error:</strong> No title could be found" unless ENV['RACK_ENV'] == 'production'
        end
    end
    
    # Finds the datetime of a given content entry in the database
    #
    # @param [Object] a content object overide to the default functionality
    # @param [String] a special override to adjust the format of the datetime
    # @return The datetime of the passed object
    def the_datetime(content=nil, output=nil)
        if node = content || @content || Content.get(params[:id])
            output.nil? ? node.created_at : node.created_at.strftime(output)
        else
            flash[:error] = "<strong>Error:</strong> No creation date could be found" unless ENV['RACK_ENV'] == 'production'
        end
    end
    
    # Finds the datetime of a given content entry in the database
    #
    # @param [Object] a content object overide to the default functionality
    # @param [String] a special override to adjust the format of the datetime
    # @return The datetime of the passed object
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
    # @param [Object] a content object overide to the default functionality
    # @return The truncated content of the passed object
    def the_excerpt(content=nil)
        if node = content || @content || Content.get(params[:id])
            
            length = 100
            
            # Truncate content
            text = Maruku.new("#{node.body}").to_html.gsub(/<\/?[^>]*>/, "").split(" ")[0..length].join(" ")
            
            # Add ellipse if any content was truncated
            text += "..." unless node.body.split(" ").length < length
            
            return "<p> #{text} </p>"
            
        else
            flash[:error] = "<strong>Error:</strong> No content could be found" unless ENV['RACK_ENV'] == 'production'
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
            flash[:error] = "<strong>Error:</strong> No link could be found" unless ENV['RACK_ENV'] == 'production'
        end
    end
    
    # Finds the primary key of a given content entry in the database
    #
    # @param [Object] a content object overide to the default functionality
    # @return The ID of the passed content object
    def the_id(content=nil)
        if node = content || @content || Content.get(params[:id])
            node.id
        else
            flash[:error] = "<strong>Error:</strong> No content identifier could be found" unless ENV['RACK_ENV'] == 'production'
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
            flash[:error] = "<strong>Error:</strong> No template information could be found" unless ENV['RACK_ENV'] == 'production'
        end
    end

    # At last, the magic:
    def proto_loop(type="posts")
        
        if type == "pages"
            posts = Content.pages
        else
            posts = Content.posts.reverse
        end
        
        posts.each do |post|
        
            @content = post
            
            yield
            
        end
        
    end

end