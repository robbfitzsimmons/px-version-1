class Invite
  include DataMapper::Resource

  property :id,					  Serial                       #
  property :email,        String, :length => 250                        # 
  property :slug,         String, :length => 500                        # Unique indentifier URL
  property :visited,      Boolean, :default => false    # Has the slug been visited?
  property :hide,         Boolean, :default => false

  before :valid?, :remove_html
  
  before :valid?, :create_slug

  validates_presence_of :email
  validates_presence_of :slug
  validates_uniqueness_of :email, :scope => :event_id
  validates_uniqueness_of :slug
  validates_format_of :email, :as => :email_address

  #property :event_id,     Integer   # Links an invite to an event
  #property :user_id,      Integer   # Links an invite to a user (must have registered or already a member)

  property :created_at,   DateTime  # Generated when each resource is created
  property :updated_at,   DateTime  # Generated when each resource is updated

  ## Links an invite to an event
  belongs_to :event
  belongs_to :user, :required => false	# Link created when signing up a user if their email exists in user database or when if they register given this invite

  validates_uniqueness_of :user_id, :scope => :event_id   # Insure a unique user for each event
end