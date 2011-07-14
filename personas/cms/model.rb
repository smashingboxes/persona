#######################################################
# CMS Model
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
    
    property :position,           Integer,                                                     :default => 0
    
    property :created_at,         DateTime,                                                    :default => Time.now
    property :updated_at,         DateTime,                                                    :default => Time.now
  
    # Allows to use the content_type as a class method, e.g., Content.post, Content.page
    # Todo: Add an singularize method and use the plural form of content_type as method name.
    def self.method_missing(name, *args)
      self.all(:content_type => name.to_s)
    end
    
  end
  
  DataMapper.finalize
  DataMapper.auto_upgrade!

  # Updates the system data table with more attributes
  class System
    
    property :description,     String,       :required => false,     :default => "A basic CMS"
    property :homepage,        Integer,      :required => true,      :default  => 0
  
    def self.description
      self.first.description
    end
    
    def self.homepage
      self.first.homepage
    end 
    
  end
        
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
