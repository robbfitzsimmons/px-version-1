class UserEventAssociation
  include DataMapper::Resource

  #property :id,					  	Serial    #
 
  # property :user_id,        Integer    # Links an event to a user
  # property :event_id,		    Integer    # Links an user to an event
  
  property :admin,    			Boolean, :default => false   # Is the user_id the admin of the event_id?
  property :attending,    	Boolean, :default => false   # Is the user_id the attending
  property :checked_in, 		Boolean, :default => false		# Has the user_id checked in on the day of event_id?

  belongs_to :user,   :key => true
  belongs_to :event,   :key => true

end