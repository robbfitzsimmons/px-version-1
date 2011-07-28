class Organization
  include DataMapper::Resource

  property :id,					  Serial                       #
  property :name,         String

  validates_uniqueness_of :name

  property :created_at,   DateTime  # Generated when each resource is created
  property :updated_at,   DateTime  # Generated when each resource is updated

  ## Links an interest to a user
  has n, :users, :through => Resource

end