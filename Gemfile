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
gem "dm-paperclip", :git => "git://github.com/pdud/dm-paperclip.git"
gem "pdfkit"

group :development do
  gem "dm-sqlite-adapter"
  gem "dm-sweatshop"
  gem "wkhtmltopdf-binary"
end

group :production do
  gem "mail"
  gem "aws-s3"
  gem "dm-postgres-adapter"			# allows database to work on Heroku
end

group :development do
end