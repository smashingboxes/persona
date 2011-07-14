#######################################################
#                    CMS Persona                      #
#######################################################

_location = File.dirname(__FILE__)

puts "Found CMS persona at: " + _location

# Fire up the core framework
require_all "#{_location}/model.rb",        # => Sets up the database
            "#{_location}/helpers.rb",       # => Basic helper functions for templates
            "#{_location}/controller.rb"    # => Sets up routes