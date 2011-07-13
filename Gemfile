source :rubygems

gem "rack"                      # the base of the base
gem "sinatra"                   # the base of our web app
gem "rack-flash"                # enables flash[:notice] && flash[:error]
gem "thin"                      # thin server

gem "dm-core"
gem "dm-migrations"
gem "dm-validations"
gem "dm-timestamps"
gem "dm-sqlite-adapter"

group :production do
  # gem 'pony'
  gem "dm-postgres-adapter"
end

group :development do
end