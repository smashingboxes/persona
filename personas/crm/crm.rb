
  require 'data_mapper'
  require "./personas/tools/mail/mail.rb"

  # Creates a datatable to support contact information
  class Contact
    include DataMapper::Resource
    
    property :id,              Serial
    property :name ,           String,       :required => true,      :message => "Please specify a name."
    property :company,         String
    property :email,           String
    property :website,         String
    
    property :created_at,      DateTime,     :default => Time.now
    property :updated_at,      DateTime,     :default => Time.now
      
  end
  
  DataMapper.finalize
  Contact.auto_upgrade!