class Invite
  include DataMapper::Resource

  property :id,					  Serial    #
  property :email,        String    # 
  property :slug,         String    # Unique indentifier URL
  property :visited,      String    # Has the slug been visited?

  #property :event_id,     Integer   # Links an invite to an event
  #property :user_id,      Integer   # Links an invite to a user (must have registered or already a member)

  property :created_at,   DateTime  # Generated when each resource is created
  property :updated_at,   DateTime  # Generated when each resource is updated

  ## Links an invite to an event
  belongs_to :event
  belongs_to :user, :required => false	# Link created when signing up a user if their email exists in user database or when if they register given this invite
end