require 'coffee-script'
require 'sass'
require 'sinatra'
require 'sinatra/base'
require 'sinatra/reloader'
require 'slim'

require './models/dbAccessers'

class MainApp < Sinatra::Base
  get '/' do
    @aryPosts = Post.all
    @aryTags = Tag.joins(:taglinks)
    slim :blog
  end
  get '/css/stylesheet.css' do
    sass :'css/stylesheet'
  end

  get '/js/javascript.js' do
    coffee :'js/javascript'
  end
end
