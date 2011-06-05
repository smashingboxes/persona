helpers do
        
    def the_title(content=nil)
        if node = content || Content.get(params[:id])
            node.title
        else
            flash[:error] = "<strong>Error:</strong> No title could be found" unless ENV['RACK_ENV'] == 'production'
        end
    end
    
    def the_content(content=nil)    
        if node = content || Content.get(params[:id])
            Maruku.new("#{node.body}").to_html 
        else
            flash[:error] = "<strong>Error:</strong> No content could be found" unless ENV['RACK_ENV'] == 'production'
        end
    end
        
    def the_excerpt(content=nil)
        if node = content || Content.get(params[:id])
            
            length = 100
            
            # Truncate content
            text = node.body.split(" ")[0..length].join(" ").gsub(/<\/?[^>]*>/, "")
            
            # Add ellipse if any content was truncated
            text += "..." unless node.body.split(" ").length < length
            
            return "<p> #{text} </p>"
            
        else
            flash[:error] = "<strong>Error:</strong> No content could be found" unless ENV['RACK_ENV'] == 'production'
        end
    end
    
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
    
    def proto_loop()
    
        posts = Content.pages
        
        posts.each do |post|
        
            @post = post
            
            @the_title = the_title(post)
            @the_content= the_content(post)
            @the_excerpt = the_excerpt(post)
            
            yield
            
        end
        
    end

end