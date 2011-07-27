#######################################################
#                    CMS Persona                      #
#######################################################

module Persona
  class Base < Sinatra::BigBand
    
    # Fire up the core framework
    require_all "#{File.dirname(__FILE__)}/helpers.rb",
                "#{File.dirname(__FILE__)}/model.rb",
                "#{File.dirname(__FILE__)}/controller.rb"
    
    include Persona::CMS
    
  end
    
end