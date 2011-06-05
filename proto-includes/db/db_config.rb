require 'rubygems'
require 'data_mapper'

DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite://#{Dir.pwd}/proto-includes/db/proto.db")

class Content
  include DataMapper::Resource

  property :id,                 Serial
  property :title,              String,                 :required => true,      :message => "Please specify a title for this page."
  property :body,               Text,                   :required => true,      :message => "Please specify body content for this page."
  property :content_type,       Enum[:post, :page],     :required => true,      :message => "Please specify the content type."
  property :parent,             Integer,                :default => 0
  property :created_at,         DateTime
  
  def self.posts
    all(:content_type => :post)
  end

  def self.pages
    all(:content_type => :page)
  end
end

class Content
  property :template,           String,                 :default => "single"
end


DataMapper.finalize
DataMapper.auto_upgrade!