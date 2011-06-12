require './proto-includes/controller.rb'  # <-- your sinatra app
require 'rspec'
require 'rack/test'

set :environment, :test

describe 'Prototypical' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  it "has a homepage" do
    get '/'
    last_response.should be_ok
  end
end