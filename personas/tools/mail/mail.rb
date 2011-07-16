#######################################################
#                 Table of Contents                   #
#######################################################
#                                                     #
# 1) Models                                           #
# 2) Controllers                                      #
# 3) Helper Methods                                   #
# 4) Authentication Workhorse                         #
#                                                     #
#######################################################

require 'sinatra/base'

#######################################################
# 1) Models
#######################################################

# Extend System to include an admin email address
class System
  
  property :admin_email,              String,           :required => true,      :default => "admin@foobar.com", :message => "Please specify an admin email address."
  property :admin_email_password,     String,           :required => true,      :default => "foobar", :message => "Please specify the password for your email address."

  validates_format_of :admin_email, :as => :email_address
  
  def self.email_address
    System.first.admin_email
  end
  
  def self.email_password
    System.first.admin_email_password
  end
  
end

DataMapper.finalize
System.auto_upgrade!


#######################################################
# 2) Routes
#######################################################

  post "/contactme" do 
    
    begin
      email "nate.hunzaker@gmail.com", "Hey Nate!", "How are you doing?"
    rescue Exception => e
      flash[:error] = "<strong>Oops!</strong> The following error occurred:<hr/>#{e}"
    end
     
    redirect '/admin'
    
  end

#######################################################
# 3) Helpers
#######################################################

helpers do

  # Sends mail using the Pony Gem
  #
  # to           - The address to recieve the email
  # subject      - The subject line of the email
  # template     - The view file to use for the body of the message
  # notification - A message to send back to the user that the
  #                email was sent correctly
  #
  def email(to=System.email, subject='Persona : You have a new message!', body='Hello!', notification="Email was successfully sent!")
    
    require 'pony'
    
    # We set the layout to false so that emails are not clogged with layout.erb
    set :layout => false
    
    Pony.mail :to                       => to,
              :via                      => :smtp, 
              :via_options              => {
                  :address              => 'smtp.gmail.com',
                  :port                 => '587',
                  :enable_starttls_auto => true,
                  :user_name            => System.email_address,
                  :password             => System.email_password,
                  :authentication       => :plain, # :plain, :login, :cram_md5, no auth by default
                  :domain               => "personacms.heroku.com",
               },            
               :subject                 => subject,
               :body                    => body
    
    # Let the user know the email was sent successfully
    flash[:success] = notification
          
  end
  
end