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

  property :linked_in,	String		#
  property :facebook,		String		#
  property :twitter,		String		#
  
  property :website,		String		#
  property :image,			String		# URL Pulled from social service or added using File upload to Amazon (http://ididitmyway.heroku.com/past/2011/1/16/uploading_files_in_sinatra/)
  property :location,		String		# Location of the user (ex. Massachusetts)

  property :created_at, DateTime  # Generated when each resource is created
  property :updated_at, DateTime  # Generated when each resource is updated

  ## Links users to events
  has n, 	 :user_event_associations
  has n,	 :events, :through => :user_event_associations

  ## Links users to speakers
  has n,   :presentations
  has n,   :time_slots, :through => :presentations

  ## Links a user to multiple invites
  has n,   :invites

  has n,   :answers

  before :save, :encrypt_password

  # Lists topics a user is speaking in as speeches
  def speeches
    self.time_slots
  end

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