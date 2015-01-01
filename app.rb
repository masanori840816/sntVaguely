require 'coffee-script'
require 'sass'
require 'sinatra'
require 'sinatra/base'
require 'sinatra/reloader'
require 'slim'

require './models/dbAccessers'

class MainApp < Sinatra::Base
  get '/' do
    @aryPosts = Post.all.order(post_id: 'desc')
    @aryTags = getLinkedTags
    slim :blog
  end
  get '/tag/:name' do
    puts "tag"
    @aryPosts = Post.joins(:taglinks).where(taglinks: {tag_id: params[:name]}).order(post_id: 'desc')
    @aryTags = getLinkedTags
    slim :blog
  end
  get '/css/stylesheet.css' do
    sass :'css/stylesheet'
  end

  get '/js/javascript.js' do
    coffee :'js/javascript'
  end
  def getLinkedTags()
    aryLinkedTag = Tag.joins(:taglinks).select(:tag_name, :post_id, :tag_id)
    aryLinkedTag
  end
end
