class Day
  include DataMapper::Resource

  property :id,					      Serial    #
  property :name,             String    #
  property :description,      String    #
  property :location,         String    #
  
  property :date,             DateTime	#

  validates_presence_of :date
  
  property :created_at,       DateTime  # Generated when each resource is created
  property :updated_at,       DateTime  # Generated when each resource is updated

  before :valid?, :remove_html

  ## Links a day to an event
  belongs_to :event

  ## Links day to sessions
  has n,     :sessions

end