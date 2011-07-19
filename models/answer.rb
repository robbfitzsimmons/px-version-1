class Answer
  include DataMapper::Resource

  property :id,					  	Serial    #
 
  #property :user_id,        Integer    # Links an answer to a user
  #property :question_id,    Integer    # Links an answer to a question
  
  property :text_answer,    String    # An answer to question_id, that is a String
  property :int_answer, 		Integer		# An answer to question_id, that is an int (or boolean)

  property :created_at,   	DateTime  # Generated when each resource is created
  property :updated_at,   	DateTime  # Generated when each resource is updated

  # Weird problem where this is created (never used) - so overwrite it and  make it not required
  property :question_event_id, Integer, :required => false

  # Links an answer to a question and a user
  belongs_to :question,   :key => true
  belongs_to :user

  validates_uniqueness_of :user, :scope => :question_id

  validates_numericality_of :int_answer, :integer_only => true, :gte => 0, :allow_nil => true

end