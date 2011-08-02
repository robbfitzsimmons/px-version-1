class Event
  include DataMapper::Resource
  include Paperclip::Resource

  property :id,					  Serial    #
  property :name,         String, :length => 50     #
  property :description,  String, :length => 250
  property :color,  	  String,   :default => "blue" #
  #property :logo,         String    # URL linking to Amazon File Upload (http://ididitmyway.heroku.com/past/2011/1/16/uploading_files_in_sinatra/)
  property :permalink,    String    # A link to take you to the event

  before :valid?, :remove_html

  before :valid?, :create_permalink
  validates_with_method :name, :method => :check_name

  validates_presence_of :name
  
  property :start_date,   DateTime	#
  property :end_date,     DateTime	#

  validates_presence_of :start_date
  validates_presence_of :end_date
  validates_with_method :end_date, :method => :valid_end_date?, :if => lambda { |t| t.start_date != nil && t.end_date != nil}

  
  property :location,     String, :length => 50     # Name of location
  property :latitude,		  Float	, :default => 0	  # Latitude of location (useful for Google Maps)
  property :longitude,	  Float,  :default => 0		  # Longtitude of location (useful for Google Maps)
  property :language,     String    # 

  validates_presence_of :location
  validates_numericality_of :latitude
  validates_numericality_of :longitude

  property :created_at,   DateTime  # Generated when each resource is created
  property :updated_at,   DateTime  # Generated when each resource is updated

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
                                 :thumb => "75x75#" }
  else
    has_attached_file :image,
                    :url => "/uploads/:class/:attachment/:id/:style/:basename.:extension",
                    :path => "#{APP_ROOT}/public/uploads/:class/:attachment/:id/:style/:basename.:extension",
                    :styles => { :original => "300x300#",
                                 :thumb => "75x75#" }
  end

  validates_with_method :image, :method => :validates_image_type 
  validates_with_method :image, :method => :validates_image_size

  ## Links events to users
  has n,   :user_event_associations
  has n,   :users, :through => :user_event_associations


  ## Links an event to multiple time_slots and multiple invites and multiple questions
  has n, :days
  has n, :invites
  has n, :questions

  after :save, :create_days

  def check_name

    dissallowed_names = %w{"login", "logout", recover", "users", "invites", "activities", "questions", "events", "sessions"} 

    if self.attribute_dirty?(:name)
      self.name = self.name.squeeze(" ").strip
      event_names = Event.all
      valid = true
      event_names.each do |event|
        if event.name.downcase != self.name.downcase
          valid = true
        else
          valid = false
          break
        end # end if
      end # end do

      if dissallowed_names.one? {|dissallowed_name| dissallowed_name.match(self.name)}
        valid = false
      end


      if valid == false
        [ false, "An event called '#{self.name}' is already registered." ]
      else
        true
      end
    else
      return true
    end
  end # end check name

  def create_days
    if self.days.count != self.end_date.mjd - self.start_date.mjd + 1
      num_days = self.end_date.mjd - self.start_date.mjd + 1

      1.upto(num_days) { |i|
        @day = Day.create(:name => "Day #{i}", :date => (self.start_date.to_time + ((i-1) * 86400)).to_datetime, :event => self)
        @day.errors.each do |e|
          puts e
        end
      }
    end
  end

  
end