# ##################################################### #
# A place to edit the functionality of your persona app #
# ##################################################### #

# Warning, having multiple personalities could make you crazy,
# tread lightly

load_persona "cms"
load_persona "crm"

# Deals
class Deal
  include DataMapper::Resource

  property :id,                 Serial
  property :title,              String,                   :required => true,            :message => "Please specify a title for this content."
  property :description,        Text
  property :deal_type,          Enum[:zeek, :monster],    :required => true,            :default => :zeek
  property :author,             Integer,                  :default => User.first.id
      
  property :created_at,         DateTime,                 :default => Time.now
  property :updated_at,         DateTime,                 :default => Time.now

  # Allows to use the content_type as a class method, e.g., Content.post, Content.page
  # Todo: Add an singularize method and use the plural form of content_type as method name.
  def self.method_missing(name, *args)
    self.all(:content_type => name.to_s)
  end
  
end

DataMapper.finalize
DataMapper.auto_upgrade!