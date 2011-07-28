#######################################################
#                    CMS Persona                      #
#######################################################

module Persona
  class Base < Sinatra::BigBand
    
    # Fire up the core framework
    require_all "#{File.dirname(__FILE__)}/helpers",
                "#{File.dirname(__FILE__)}/model",
                "#{File.dirname(__FILE__)}/controller"
    
    include Persona::CMS
    
  end
    
end