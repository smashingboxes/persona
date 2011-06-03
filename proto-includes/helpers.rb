helpers do

    def the_title()
        if params[:id]
            Page.get(params[:id]).title
        else
            flash[:error] = "<strong>Error:</strong> No title could be found" unless ENV['RACK_ENV'] == 'production'
        end
    end
    
    def the_content()
        if params[:id]
            @page = Page.get(params[:id])
            Maruku.new("#{@page.body}").to_html 
        else
            flash[:error] = "<strong>Error:</strong> No content could be found" unless ENV['RACK_ENV'] == 'production'
        end
    end
    
end
