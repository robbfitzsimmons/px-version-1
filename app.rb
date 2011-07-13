# Import all Models and Controllers
Dir.glob("#{Dir.pwd}/models/*.rb") { |m| require "#{m.chomp}" }
Dir.glob("#{Dir.pwd}/controllers/*.rb") { |m| require "#{m.chomp}" }

# Set up database
DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite://#{Dir.pwd}/db/proximate.db")

# Initialize (finalize) db
DataMapper.finalize

# Create the db/tables if they don't exist
DataMapper::auto_upgrade!

get '/' do
  @title = 'Hey there!'
  
  erb :index
end