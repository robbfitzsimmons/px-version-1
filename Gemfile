source :rubygems

gem "rack"                      # the base of the base
gem "sinatra"                   # the base of our web app
gem "rack-flash"                # enables flash[:notice] && flash[:error]
gem "thin"                      # thin server

gem "dm-core"
gem "dm-migrations"
gem "dm-validations"
gem "dm-timestamps"

gem "omniauth"

gem "sass" 

group :development do
  # gem 'pony'
  gem "dm-sqlite-adapter"
end

group :production do
  # gem 'pony'
  gem "dm-postgres-adapter"			# allows database to work on Heroku
end

group :development do
end