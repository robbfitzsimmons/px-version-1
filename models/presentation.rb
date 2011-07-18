class Presentation
  include DataMapper::Resource

  property :id,					  	Serial    #
 
  # property :user_id,        Integer    # Links an user to a topic
  # property :topic_id,		    Integer    # Links a topic to a user

  # Links speaker to a user and a time slot
  belongs_to :user,   :key => true
  belongs_to :activity,   :key => true

end