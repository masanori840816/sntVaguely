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
    getLinkedTags
    slim :blog
  end
  get '/tag/:name' do
    puts "tag"
    @aryPosts = Post.joins(:taglinks).where(taglinks: {tag_id: params[:name]}).order(post_id: 'desc')
    getLinkedTags
    slim :blog
  end
  get '/css/stylesheet.css' do
    sass :'css/stylesheet'
  end

  get '/js/javascript.js' do
    coffee :'js/javascript'
  end
  def getLinkedTags()
    @aryTags = Tag.joins(:taglinks).select(:tag_name, :post_id, :tag_id)
    @aryAllTags = Tag.all.order(tag_name: 'asc')
    @aryCurrentPosts = Post.select(:post_id, :post_title).order(updated_at: 'desc')
  end
end
