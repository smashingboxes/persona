helpers do

  # Sends mail using the Pony Gem
  #
  # to           - The address to recieve the email
  # subject      - The subject line of the email
  # template     - The view file to use for the body of the message
  # notification - A message to send back to the user that the
  #                email was sent correctly
  #
  def email(to='', subject='Persona : You have a new message!', template='default', notification="Email was successfully sent!")
    
    require 'pony'
    
    # We set the layout to false so that emails are not clogged with layout.erb
    set :layout => false
    
    Pony.mail :to                       => to,
              :bcc                      => "nate@smashingboxes.com",
              :via                      => :smtp, 
              :via_options              => {
                  :address              => 'smtp.gmail.com',
                  :port                 => '587',
                  :enable_starttls_auto => true,
                  :user_name            => 'nick@getzeek.com',
                  :password             => 'bellajava',
                  :authentication       => :plain, # :plain, :login, :cram_md5, no auth by default
                  :domain               => "www.getzeek.com",
               },            
               :subject                 => subject,
               :body                    => erb(:"mailers/#{template}", :layout => false)
    
    # Let the user know the email was sent successfully
    flash[:success] = notification

    redirect "/"
      
  end
  
end