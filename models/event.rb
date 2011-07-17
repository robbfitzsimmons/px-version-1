class Event
  include DataMapper::Resource

  property :id,					  Serial    #
  property :name,         String    #
  property :description,  String    #
  property :logo,         String    # URL linking to Amazon File Upload (http://ididitmyway.heroku.com/past/2011/1/16/uploading_files_in_sinatra/)
  property :permalink,    String    # A link to take you to the event

  #before :valid?, :create_permalink

  validates_presence_of :name
  validates_uniqueness_of :name
  
  property :start_date,   DateTime	#
  property :end_date,     DateTime	#

  validates_presence_of :start_date
  validates_presence_of :end_date
  validates_with_method :end_date, :method => :valid_end_date?, :if => lambda { |t| t.start_date != nil && t.end_date != nil}

  
  property :location,     String    # Name of location
  property :latitude,		  Float	, :default => 0	  # Latitude of location (useful for Google Maps)
  property :longitude,	  Float,  :default => 0		  # Longtitude of location (useful for Google Maps)
  property :language,     String    # 

  validates_presence_of :location
  validates_numericality_of :latitude
  validates_numericality_of :longitude

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