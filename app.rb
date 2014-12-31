require 'coffee-script'
require 'sass'
require 'sinatra'
require 'sinatra/base'
require 'sinatra/reloader'
require 'slim'

require './models/dbAccessers'

class MainApp < Sinatra::Base
  acrContent = Content.new

  get '/' do
    #blcContents.getContents
    @aryContents = Content.all
    #@aryFullContents = Content.joins(:
    slim :blog
  end
  get '/css/stylesheet.css' do
    sass :'css/stylesheet'
  end

  get '/js/javascript.js' do
    coffee :'js/javascript'
  end
end
