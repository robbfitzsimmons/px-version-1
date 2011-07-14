class TimeSlot
  include DataMapper::Resource

  property :id,					      Serial    #
  property :name,             String    #
  property :description,      String    #
  property :location,         String    # Name of location
  
  property :start_date,       DateTime	#
  property :end_date,         DateTime	#

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