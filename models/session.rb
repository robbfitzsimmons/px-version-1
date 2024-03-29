class Session
  include DataMapper::Resource

  property :id,					      Serial    #
  property :name,             String, :length => 50     #
  property :description,      String, :length => 50     #
  property :location,         String, :length => 50     #

  before :valid?, :remove_html

  validates_presence_of :name
  
  property :start_date,       DateTime	#
  property :end_date,         DateTime	#

  validates_presence_of :start_date
  validates_presence_of :end_date
  validates_with_method :end_date, :method => :valid_end_date?, :if => lambda { |t| t.start_date != nil && t.end_date != nil}
  
  property :created_at,       DateTime  # Generated when each resource is created
  property :updated_at,       DateTime  # Generated when each resource is updated

  ## Links a session to a day
  belongs_to :day

  ## Links sessions to activites
  has n,     :activities

end