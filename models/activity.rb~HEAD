class Activity
  include DataMapper::Resource

  property :id,					      Serial    #
  property :name,             String    #
  property :description,      String    #
  property :location,         String    # Name of location

  validates_presence_of :name
  
  property :start_date,       DateTime	#
  property :end_date,         DateTime	#

  validates_presence_of :start_date
  validates_presence_of :end_date
  validates_with_method :end_date, :method => :valid_end_date?, :if => lambda { |t| t.start_date != nil && t.end_date != nil}

  #property :speaker_user_id,  Integer   # Links a topic to a speaker
  #property :event_id,         Integer   # Links a topic to an event
  
  property :created_at,       DateTime  # Generated when each resource is created
  property :updated_at,       DateTime  # Generated when each resource is updated

  ## Links a timeslot to an event
  belongs_to :event

  ## Links timeslot to users
  has n,     :presentations
  has n,     :users, :through => :presentations

end