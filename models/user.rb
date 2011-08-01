require 'digest'
require 'open-uri'

class User
  include DataMapper::Resource
  include Paperclip::Resource

  attr_accessor :image_url

  before :valid?, :remove_html

  property :id,					Serial    #
  property :name,       String    #
  property :description,String    #
  property :email,       String    #

  property :curator,       Boolean, :default => false    # Future for paid subscriptions

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
  #property :image,			String, :length => 500  		# URL Pulled from social service or added using File upload to Amazon (http://ididitmyway.heroku.com/past/2011/1/16/uploading_files_in_sinatra/)
  property :location,		String		# Location of the user (ex. Massachusetts)
  property :work,			String		# User's Work
  property :education,     String    # User's education

  property :created_at, DateTime  # Generated when each resource is created
  property :updated_at, DateTime  # Generated when each resource is updated
  if (ENV['RACK_ENV']) == "production"
    #  ENV['S3_BUCKET'],ENV['S3_KEY'], ENV['S3_SECRET']
    puts "S3"
    has_attached_file :image,
                    :storage => :s3,
                    #:s3_permissions => :public_read
                    #:s3_credentials => "#{APP_ROOT}/config/s3.yml",
                    :s3_credentials => {
                      :access_key_id => ENV['S3_KEY'],
                      :secret_access_key => ENV['S3_SECRET']
                    },
                    :path => "/:class/:attachment/:id/:style/:basename.:extension",
                    :bucket         => "proximate_test",
                    :styles => { :original => "300x300#",
                                 :thumb => "80x80#" }
  elsif (ENV['RACK_ENV']) == "OOHHHH"
    puts "S3"
    has_attached_file :image,
                    :storage => :s3,
                    #:s3_permissions => :public_read
                    :s3_credentials => "#{APP_ROOT}/config/s3.yml",
                    :path => "/:class/:attachment/:id/:style/:basename.:extension",
                    :bucket         => "proximate_dev",
                    :styles => { :original => "300x300#",
                                 :thumb => "80x80#" }
  else
    has_attached_file :image,
                    :url => "/uploads/:class/:attachment/:id/:style/:basename.:extension",
                    :path => "#{APP_ROOT}/public/uploads/:class/:attachment/:id/:style/:basename.:extension",
                    :styles => { :original => "300x300#",
                                 :thumb => "80x80#" }
  end

    
  ## Links users to events
  has n, 	 :user_event_associations
  has n,	 :events, :through => :user_event_associations

  ## Links users to speakers
  has n,   :presentations
  has n,   :activities, :through => :presentations

  ## Links a user to multiple invites
  has n,   :invites

  has n,   :answers

  ## Links a user to interests
  has n, :interests, :through => Resource

  ## Links a user to organizations
  has n, :organizations, :through => Resource

  before :save, :encrypt_password

  before :valid?, :download_remote_image
  validates_with_method :image, :method => :validates_image_type 
  validates_with_method :image, :method => :validates_image_size


  # Lists topics a user is speaking in as speeches
  def speeches
    self.time_slots
  end

  # Lists related people
  def people_matches
    matches = []
    all_matches = self.organizations.users + self.interests.users
    all_matches = all_matches.uniq
    if all_matches.count <= 4
      matches = all_matches
    else
      while(matches.count < 4)
        matches << all_matches[1+ rand(all_matches.count)]
        matches = matches.uniq
      end
    end
    matches
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

  def questions_this_event(event)
    this_event = self.events.first(:id => event.id)
    if this_event.nil?
      return Hash.new
    else
      all_questions_this_event = self.events.first(:id => event.id).questions

      # Get questions the user has answered already
      questions_user_has_answered = self.answers.questions(:event => event)

      # Remove questions the user has answered from all the questions leaving unanswered questions
      questions_user_has_answered.each do |answered_question|  
        all_questions_this_event.delete_if{ |question| (question == answered_question)}
      end
    return all_questions_this_event
    end  
  end

  private
    def encrypt_password
      if self.attribute_dirty?(:password)
        self.salt = make_salt if new? 
        self.password = encrypt(password)
      end
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

    def download_remote_image
      if !image_url.nil?
        self.image = do_download_remote_image
      end
    end

    def do_download_remote_image
        io = open(URI.parse(image_url))
        def io.original_filename; base_uri.path.split('/').last; end
        io.original_filename.blank? ? nil : io
      rescue # catch url errors with validations instead of exceptions (Errno::ENOENT, OpenURI::HTTPError, etc...)
    end

end