#######################################################
#                    CMS Persona                      #
#######################################################
#                                                     #
#######################################################
#                 Table of Contents                   #
#######################################################
#                                                     #
# 1) Model                                            #
# 2) Controller                                       #
#    a) Basic Content CRUD                            #
#    b) Administration Panel                          #
# 3) Helper Methods                                   #
#    a) General Helper Methods                        #
#    b) Protoloop Methods                             #
#       i) the author                                 #
#      ii) the_content                                #
#     iii) the_content_type                           #
#      iv) the_datetime                               #
#      vi) the_excerpt                                #
#     vii) the_id                                     #
#    viii) the_link                                   #
#      ix) the_parent                                 #
#       x) the_title                                  #
#      xi) the_template                               #
#                                                     #
#######################################################

_location = File.dirname(__FILE__)

puts "Found CMS persona at: " + _location

# Fire up the core framework
require_all "#{_location}/model.rb",        # => Sets up the database
            "#{_location}/helpers.rb",       # => Basic helper functions for templates
            "#{_location}/controller.rb"    # => Sets up routes