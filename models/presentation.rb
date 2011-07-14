class Presentation
  include DataMapper::Resource

  property :id,					  	Serial    #
 
  # property :user_id,        String    # Links an user to a topic
  # property :topic_id,		    String    # Links a topic to a user

  # Links speaker to a user and a time slot
  belongs_to :user,   :key => true
  belongs_to :time_slot,   :key => true

end