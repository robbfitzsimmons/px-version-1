require 'digest'

class User
  include DataMapper::Resource

  property :id,					Serial    #
  property :name,       String    #
  property :description,String    #
  property :email,       String    #

  validates_presence_of :name
  validates_presence_of :email
  validates_format_of :email, :as => :email_address
  validates_uniqueness_of :email
  
  property :password,   String, :length => 6..500		#
  property :salt,   		String, :length => 6..500		#

  validates_presence_of :password
  #validates_presence_of :salt

  property :linked_in,	String,		:length => 500#
  property :facebook,		String,		:length => 500#
  property :twitter,		String,		:length => 500#

  property :linked_in_uid,  String,    :length => 500#
  property :facebook_uid,   String,   :length => 500#
  property :twitter_uid,    String,    :length => 500#
  
  property :website,		String,	:length => 500 #
  property :image,			String, :length => 500  		# URL Pulled from social service or added using File upload to Amazon (http://ididitmyway.heroku.com/past/2011/1/16/uploading_files_in_sinatra/)
  property :location,		String		# Location of the user (ex. Massachusetts)

  property :created_at, DateTime  # Generated when each resource is created
  property :updated_at, DateTime  # Generated when each resource is updated

  ## Links users to events
  has n, 	 :user_event_associations
  has n,	 :events, :through => :user_event_associations

  ## Links users to speakers
  has n,   :presentations
  has n,   :activities, :through => :presentations

  ## Links a user to multiple invites
  has n,   :invites

  has n,   :answers

  before :save, :encrypt_password

  # Lists topics a user is speaking in as speeches
  def speeches
    self.time_slots
  end

  # Lists related people
  def people_matches
    @users = User.all(:limit => 4, :id.not => self.id)
  end

  def events_with_unanswered_questions
    # Get users events questions
    all_questions = self.events.questions

    # Get questions the user has answered already
    questions_user_has_answered = self.answers.questions
    
    # Remove questions the user has answered from all the questions leaving unanswered questions
    #available_teams.delete_if{ |available_team| (available_team.id == keep_game.home_id || available_team.id == keep_game.away_id)}
    questions_user_has_answered.each do |answered_question|  
      all_questions.delete_if{ |question| (question == answered_question)}
    end

    events = Array.new
    all_questions.each do |question|
      if !events.include?(question.event)
        events << question.event
      end
    end
    events.inspect
    events

  end

  # List all invites the user has chosen not to hide
  def new_invites
    self.invites.all(:hide => false)
  end

  def has_password?(submitted_password) 
    password == encrypt(submitted_password)
  end 

  def self.authenticate(email, submitted_password)
    user = first(:email => email) 
    return nil if user.nil? 
    return user if user.has_password?(submitted_password)
  end


  private
    def encrypt_password
      self.salt = make_salt if new? 
      self.password = encrypt(password)
    end
  
    def encrypt(string) 
      secure_hash("#{salt}--#{string}")
    end
    
    def make_salt 
      secure_hash("#{Time.now.utc}--#{password}")
    end
    
    def 
      secure_hash(string) Digest::SHA2.hexdigest(string)
    end
end