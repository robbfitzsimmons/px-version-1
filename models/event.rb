class Event
  include DataMapper::Resource

  property :id,					  Serial    #
  property :name,         String    #
  property :description,  String    #
  property :logo,         String    # URL linking to Amazon File Upload (http://ididitmyway.heroku.com/past/2011/1/16/uploading_files_in_sinatra/)
  
  property :start_date,   DateTime	#
  property :end_date,     DateTime	#

  
  property :location,     String    # Name of location
  property :latitude,		  Float		  # Latitude of location (useful for Google Maps)
  property :longitude,	  Float		  # Longtitude of location (useful for Google Maps)
  property :language,     String    # 

  property :created_at,   DateTime  # Generated when each resource is created
  property :updated_at,   DateTime  # Generated when each resource is updated


  ## Links events to users
  has n,   :user_event_associations
  has n,   :users, :through => :user_event_associations


  ## Links an event to multiple time_slots and multiple invites and multiple questions
  has n, :time_slots
  has n, :invites
  has n, :questions

end