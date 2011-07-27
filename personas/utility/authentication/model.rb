#######################################################
# Gatekeeper Models
#######################################################

class User
  include DataMapper::Resource
  
  property :id,                 Serial
  
  property :username,           String,                   :required => true,      :message => "Please specify a username."
  property :password,           String,                   :required => true,      :message => "Please specify a password."                
  
  property :first_name,         String
  property :last_name,          String
  
  # Account permissions level
  # 
  # 0 - # Subscriber    =>   No privileges
  # 1 - # Contributer   =>   Create, Edit, Delete own posts
  # 2 - # Editor        =>   Create, Edit, Delete all posts
  # 4 - # Admin         =>   Create, Edit, Delete all non-admin users and posts
  # 5 - # Superadmin    =>   Create, Edit, Delete all users and posts
  
  property :account_level,      Enum[:subscriber, :contributed, :editor, :admin, :superadmin],                  :required => true,      :default => "subscriber"
  
  property :created_at,         DateTime
  property :updated_at,         DateTime 
  
end

DataMapper.finalize
User.auto_upgrade!

if User.all.count == 0 
    
    # Create the default admin
    @user = User.create(
      :account_level => "superadmin",
      :username      => "admin",
      :password      => "admin",
      :first_name    => "Persona",
      :last_name     => "Admin",
      :created_at    => Time.now,
      :updated_at    => Time.now
    )
    
end