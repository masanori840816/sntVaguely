require 'json'
require 'rss/maker'
require 'sass'
require 'sinatra'
require 'sinatra/base'
require 'sinatra/reloader'
require 'slim'

require 'will_paginate'
require 'will_paginate/active_record'
require 'will_paginate/view_helpers/sinatra'

require './models/dbAccessers'

SITE_URL = 'http://localhost:9292'

class MainApp < Sinatra::Base
  # for using will_pagenate.
  helpers WillPaginate::Sinatra::Helpers

  configure :development do
    register Sinatra::Reloader
  end
  get '/' do
    slim :post
  end
  get '/list' do
    # get blog posts and return json data.
    intStartNum = (params[:page] =~ /\d+/ && params[:page].to_i > 0)? params[:page].to_i: 1

    aryBlogList = Post.order(post_id: 'desc').paginate(:page => intStartNum, :per_page => 5)
    aryJsonList = []

    aryTagTest = [{:title =>'tag1', :url => '/tag/1'},
        {:title => 'tag2', :url => '/tag/2'}]

    aryBlogList.each do |post|
      aryJsonList << {
        postUrl: '/article/' + post.post_id.to_s,
        postTitle: post.post_title,
        post: post.post,
        category: aryTagTest,
        updateDate: post.updated_at.strftime('%Y-%m-%d %H:%M:%S')
      }
    end
    aryJsonList.to_json
  end
  not_found do
    slim :error
  end
  get '/edit' do
    slim :newpost
  end
  post '/createnewpost' do
    jsnParams = ActiveSupport::JSON.decode(request.body.read)
    puts jsnParams['title']
    puts jsnParams['article']
    jsnParams['tags'].each do |selectedtag|
      puts selectedtag
    end
    puts 'end'
  end
  get '/gettaglist' do
    aryTagList = Tag.order(tag_id: 'desc')

    aryJsonList = []
    aryTagList.each do |tag|
      aryJsonList << {
        tagid: tag.tag_id,
        tagname: tag.tag_name
      }
    end
    aryJsonList.to_json
  end
  get '/css/stylesheet.css' do
    sass :'css/stylesheet'
  end
  get '/feed' do
    # RSSフィードの出力.
    newRss = RSS::Maker.make("2.0") do |newRss|
      newRss.channel.title = "Vaguely"
      newRss.channel.description = "なんとなくやってみたことを書き残します"
      newRss.channel.link = SITE_URL
      newRss.channel.language = "ja"

      newRss.items.do_sort = true
      newRss.items.max_size = 10

      aryPosts = Post.all.order(post_id: 'desc').limit(10)
      aryPosts.each do |post|
        rssItem = newRss.items.new_item
        rssItem.title = post.post_title
        rssItem.link = SITE_URL + POST_URL_DIR + post.post_id.to_s
        rssItem.description = post.post
        rssItem.date = post.updated_at
      end
    end

    content_type "application/xml"
    newRss.to_s
  end
end
