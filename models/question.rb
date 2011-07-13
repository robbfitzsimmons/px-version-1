class Question
  include DataMapper::Resource

  property :id,					  Serial    #
  property :type,         String    # Type of Question (Radio, Text, Select)
  property :text,         String    # Question's text
  
  property :option1,      String    # If needed, question's option's text
  property :option2,      String    # If needed, question's option's text
  property :option3,      String    # If needed, question's option's text

  property :event_id,			Integer		# Links a question to an event

  property :created_at,   DateTime  # Generated when each resource is created
  property :updated_at,   DateTime  # Generated when each resource is updated

end