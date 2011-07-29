class PasswordReset
  include DataMapper::Resource

  property :id,					  Serial                       #
  property :email,        String                       # 
  property :slug,         String                       # Unique indentifier URL
  property :used,      Boolean, :default => false      # Has the slug been visited?
  
  before :valid?, :remove_html
  before :valid?, :create_slug

  validates_presence_of :email
  validates_presence_of :slug
  validates_uniqueness_of :slug
  validates_format_of :email, :as => :email_address

  property :created_at,   DateTime  # Generated when each resource is created
  property :updated_at,   DateTime  # Generated when each resource is updated
end