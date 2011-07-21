require File.dirname(__FILE__) + '/spec_helper'

describe 'Persona Core' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  it 'should have a homepage' do
    get '/'
    last_response.status.should == 200
  end
  
  it 'should have an admin panel' do
    get '/admin'
    last_response.status.should == 200
  end
  
end