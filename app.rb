APP_ROOT = File.expand_path(File.dirname(__FILE__))

# Import all Models, Controllers, Helpers
Dir.glob("#{Dir.pwd}/helpers/*.rb") { |m| require "#{m.chomp}" }
Dir.glob("#{Dir.pwd}/models/*.rb") { |m| require "#{m.chomp}" }
Dir.glob("#{Dir.pwd}/controllers/*.rb") { |m| require "#{m.chomp}" }

require 'openid/store/filesystem'
require 'fileutils'
#require 'pdfkit'

# Set up database
DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite://#{Dir.pwd}/db/proximate.db")

# Initialize (finalize) db
DataMapper.finalize

# Reset the db/tables and recreate
#DataMapper.auto_migrate!

# Create the db/tables if they don't exist
DataMapper::auto_upgrade!

if (ENV['RACK_ENV']) == "development"
	require "#{Dir.pwd}/factories/factory.rb"
end

# Set up the PDF Converter - will need to remove it from the gitignore
# if (ENV['RACK_ENV']) == "production"
# 	PDFKit.configure do |config|
#      config.wkhtmltopdf = File.join(APP_ROOT, 'bin', 'wkhtmltopdf-amd64').to_s
# 	end  
# end

use Rack::Session::Cookie, :secret => 'Xzw8TvIwQVZrnjKXkoI8SRDHhIZ65y'
use Rack::Flash

use OmniAuth::Builder do
	provider :open_id, 		OpenID::Store::Filesystem.new('./tmp')
	provider :twitter, 		'6kDJ3xRTKjubSoXL1CE41Q', 'FP4UD6lcyyMti5rGm9v3EwfAxIFqIpsDJ84cHlpbTM'
	provider :linked_in, 	'CuqtbGhGfygi_swi36LOR91i-qHQSuMpz6BstFD5lABv3n9qNcRV7Mcfu2ZaKW5g', 'DId-d7qGWoVTcsfLseckYGdD53CObk1Mp9ISDCXEu8d-HC_UrPzLrxiF3I2bKmas'
	
	if (ENV['RACK_ENV']) == "production"
		provider :facebook, 	'227605130610885', 'ff85f418057fafa85c4c8ea458cb4193'
	else
		provider :facebook, 	'174201209313410', 'cbf7277923e7325a66fe5b8ccb17d537'
	end
	# provide :service 'CONSUMER_KEY', 'CONSUMER_SECRET'
	
	## https://www.linkedin.com/secure/developer
	## https://dev.twitter.com/apps/new
end

get '/style.css' do
	scss :style
end

get '/' do
  erb :index, {:layout => false}
end