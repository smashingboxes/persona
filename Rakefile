namespace :test do   
  
  task :test do
    require './personas/core/core.rb'
    require 'test/unit'
    require 'rack/test'
    require 'sinatra/test_unit'
    
    ENV['RACK_ENV'] = 'test'
    
    class PersonaTest < Test::Unit::TestCase
      include Rack::Test::Methods
    
      def app
        Sinatra::Application
      end
      
      def test_redirect_logged_in_users_to_dashboard
        get "/admin"
        follow_redirect!
    
        assert_equal "http://localhost:9292/login", last_request.url
        assert last_response.ok?
      end
      
    end
  end
  
end