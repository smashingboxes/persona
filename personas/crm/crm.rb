  # Creates a datatable to support contact information
  class Contact
    include DataMapper::Resource
    
    property :id,              Serial
    property :name ,           String,       :required => true,      :message => "Please specify a name."
    property :company,         String
    property :email,           String
    property :website,         String
      
  end
        
  DataMapper.finalize
  DataMapper.auto_upgrade!