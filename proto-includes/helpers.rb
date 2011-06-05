helpers do

###########################
# Templating
###########################

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
    
    def get_header()
        erb :'furniture/header'
    end
    
    def get_sidebar()
        erb :'furniture/sidebar'
    end
    
    def get_footer()
        erb :'furniture/footer'
    end
    
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
    
    def the_title(content=nil)
        if node = content || @content || Content.get(params[:id])
            node.title
        else
            flash[:error] = "<strong>Error:</strong> No title could be found" unless ENV['RACK_ENV'] == 'production'
        end
    end
    
    def the_datetime(content=nil)
        if node = content || @content || Content.get(params[:id])
            node.created_at
        else
            flash[:error] = "<strong>Error:</strong> No creation date could be found" unless ENV['RACK_ENV'] == 'production'
        end
    end
    
    def the_content(content=nil)    
        if node = content || @content || Content.get(params[:id])
            Maruku.new("#{node.body}").to_html 
        else
            flash[:error] = "<strong>Error:</strong> No content could be found" unless ENV['RACK_ENV'] == 'production'
        end
    end

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
    
    def the_link(content=nil)
        if node = content || @content || Content.get(params[:id])
            "/node/#{node.id}"
        else
            flash[:error] = "<strong>Error:</strong> No link could be found" unless ENV['RACK_ENV'] == 'production'
        end
    end

    # At last, the magic:
    def proto_loop(type="post")
        
        if type="pages"
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