require 'rubygems'
require 'data_mapper'

DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite://#{Dir.pwd}/proto-includes/db/proto.db")

class Content
  include DataMapper::Resource

  property :id,                 Serial
  property :title,              String,                                             :required => true,      :message => "Please specify a title for this page."
  property :body,               Text
  property :content_type,       Enum[:post, :page, :category, :comment, :tag],      :required => true,      :message => "Please specify the content type."
  property :parent,             Integer,                                            :default => 0
  property :template,           String,                                             :default => "single"
  
  property :created_at,         DateTime
  property :updated_at,         DateTime 
  
  def self.posts
    self.all(:content_type => "post")
  end

  def self.pages
    self.all(:content_type => "page")
  end
  
  def self.categories
    self.all(:content_type => "category")
  end
  
  def self.comments
    self.all(:content_type => "comment")
  end
  
  def self.pages
    self.all(:content_type => "tag")
  end
  
end

DataMapper.finalize
DataMapper.auto_upgrade!