require 'bundler'

Bundler.require(:default, ENV['RACK_ENV'].to_sym)  # only loads environment specific gems

require 'pdfkit'
use PDFKit::Middleware

require './app'

run Sinatra::Application