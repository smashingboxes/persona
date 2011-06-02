require 'rubygems'
require 'data_mapper'

configure :development do
  # A Sqlite3 connection to a persistent database
  DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite://#{Dir.pwd}/db/proto.db")
end

configure :production do 
  # A Postgres connection:
  DataMapper.setup(:default, 'postgres://kgvrhnbnbu:1AybmVA5tnxO7HkKOFI6@ec2-174-129-222-56.compute-1.amazonaws.com/kgvrhnbnbu')
end

class Page
  include DataMapper::Resource

  property :id,         Serial    # An auto-increment integer key
  property :title,      String    # A varchar type string, for short strings
  property :body,       Text      # A text block, for longer string data.
  property :created_at, DateTime  # A DateTime, for any date you might like.
  
end

DataMapper.finalize
DataMapper.auto_upgrade!