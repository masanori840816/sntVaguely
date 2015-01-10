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

# TODO:テスト用に5件1ページで表示中。分量的にはこのままでもいいかも？
POST_LIMIT_COUNT = 5
POST_URL_DIR = "/article/"
TAG_URL_DIR = "/tag/"
POST_SHORT_LIMIT_SIZE = 300
CURRENT_POST_LIMIT_COUNT = 10
SITE_URL = 'http://localhost:9292'
RSS_LIMIT_SIZE = 10

class MainApp < Sinatra::Base
  # viewでwill_pagenateを使用するのに必要.
  helpers WillPaginate::Sinatra::Helpers

  configure :development do
    register Sinatra::Reloader
  end

  get '/' do
    @pager = Post.order(post_id: 'desc').paginate(:page => params[:page], :per_page => POST_LIMIT_COUNT)
    getShortPosts(@pager)
    getRightColumnData
    slim :blog
  end
  get '/article/:name' do
    # 記事IDからタイトルなどを検索し、詳細ページに表示する.
    aryArticle = Post.where(post_id: params[:name]).first
    @strTitle = aryArticle.post_title
    @strPost = aryArticle.post

    @datUpdateDate = aryArticle.updated_at

    searchCriteria = Post.arel_table
    # 一つ前の記事のURL、タイトルを取得する.
    aryPrevious = Post.where(searchCriteria[:post_id].lt(params[:name])).last
    if aryPrevious == nil
      @strPreviousUrl = ""
      @strPreviousTitle = ""
    else
      @strPreviousUrl = POST_URL_DIR + aryPrevious.post_id.to_s
      @strPreviousTitle = "< " + aryPrevious.post_title
    end
    # 一つ後の記事のURL、タイトルを取得する.
    aryNext = Post.where(searchCriteria[:post_id].gt(params[:name])).first
    if aryNext == nil
      @strNextUrl = ""
      @strNextTitle = ""
    else
      @strNextUrl = POST_URL_DIR + aryNext.post_id.to_s
      @strNextTitle = aryNext.post_title + " >"
    end

    @aryTagUrl = []
    @aryTagName = []
    aryTags = Tag.joins(:taglinks).select(:tag_name, :post_id, :tag_id).where(taglinks: {post_id: params[:name]})
    aryTags.each do |tag|
      @aryTagUrl << TAG_URL_DIR + tag.tag_id.to_s
      @aryTagName << tag.tag_name
    end
    getRightColumnData
    slim :article
  end
  get '/tag/:name' do
    @pager = Post.joins(:taglinks).where(taglinks: {tag_id: params[:name]}).order(post_id: 'desc').paginate(:page => params[:page], :per_page => POST_LIMIT_COUNT)
    getShortPosts(@pager)
    getRightColumnData
    slim :blog
  end
  get '/search' do
    strQuery = params[:q]
    strQuery = "%" + strQuery + "%"

    searchCriteria = Post.arel_table
    # 入力されたクエリがタイトルor本文に合致していたら取得
    @pager = Post.includes(:taglinks).where(searchCriteria[:post_title].matches(strQuery).or(searchCriteria[:post].matches(strQuery))).order(post_id: 'desc').paginate(:page => params[:page], :per_page => POST_LIMIT_COUNT)
    getShortPosts(@pager)
    getRightColumnData
    slim :blog
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
      newRss.items.max_size = RSS_LIMIT_SIZE

      aryPosts = Post.all.order(post_id: 'desc').limit(RSS_LIMIT_SIZE)
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
  def getShortPosts(aryPosts)
    # 記事一覧表示用の投稿データを取得する.
    @aryPostUrl = []
    @aryPostTitle = []
    @aryShortPost = []
    @aryUpdateDate = []
    @aryTagNames = []
    @aryTagUrls = []

    aryPosts.each do |post|
      @aryPostUrl << POST_URL_DIR + post.post_id.to_s
      @aryPostTitle << post.post_title
      strShortPost = post.post
      if strShortPost.size >= POST_SHORT_LIMIT_SIZE
        strShortPost = strShortPost[0, POST_SHORT_LIMIT_SIZE - 1]
        strShortPost += "…"
      end
      @aryShortPost << strShortPost
      @aryUpdateDate << post.updated_at

      aryTags = Tag.joins(:taglinks).select(:tag_name, :tag_id).where(taglinks: {post_id: post.post_id})
      aryTagName = []
      aryTagUrl = []
      aryTags.each do |tag|
        aryTagUrl << TAG_URL_DIR + tag.tag_id.to_s
        aryTagName << tag.tag_name
      end
      @aryTagNames << aryTagName
      @aryTagUrls << aryTagUrl
    end
    # 記事数を取得する.
    @intCount = @aryPostTitle.size - 1
  end
  def getRightColumnData()
    # 右カラムのデータを取得する.
    # 追加済みのタグを取得する.
    aryAllTags = Tag.all.order(tag_name: 'asc')
    @aryAllTagUrl = []
    @aryAllTagName = []
    aryAllTags.each do |allTag|
      @aryAllTagUrl << TAG_URL_DIR + allTag.tag_id.to_s
      @aryAllTagName << allTag.tag_name
    end
    # 最近の投稿から10件取得する.
    aryCurrentPosts = Post.select(:post_id, :post_title).order(post_id: 'desc').limit(CURRENT_POST_LIMIT_COUNT)
    @aryCurrentPostUrl = []
    @aryCurrentPostTitle = []
    aryCurrentPosts.each do |currentPost|
      @aryCurrentPostUrl << POST_URL_DIR + currentPost.post_id.to_s
      @aryCurrentPostTitle << currentPost.post_title
    end
  end
end
