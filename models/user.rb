class User
  include DataMapper::Resource

  property :id,					Serial    #
  property :name,       String    #
  
  property :password,   String		#
  property :salt,   		String		#

  property :linked_in,	String		#
  property :facebook,		String		#
  property :twitter,		String		#
  
  property :website,		String		#
  property :image,			String		# URL Pulled from social service or added using File upload to Amazon (http://ididitmyway.heroku.com/past/2011/1/16/uploading_files_in_sinatra/)
  property :location,		String		# Location of the user (ex. Massachusetts)

  property :created_at, DateTime  # Generated when each resource is created
  property :updated_at, DateTime  # Generated when each resource is updated
end