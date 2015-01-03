require 'coffee-script'
require 'sass'
require 'sinatra'
require 'sinatra/base'
require 'sinatra/reloader'
require 'slim'

require './models/dbAccessers'

# TODO:テスト用に5件1ページで表示中。分量的にはこのままでもいいかも？
POST_LIMIT_COUNT = 5
POST_URL_DIR = "/article/"
TAG_URL_DIR = "/tag/"
POST_SHORT_LIMIT_SIZE = 300

class MainApp < Sinatra::Base

  intPageOffsetNum = 0

  get '/' do
    intPageOffsetNum = getPageOffset(params[:page])

    getPagerCount(Post.count)
    aryPosts = Post.all.order(post_id: 'desc').limit(POST_LIMIT_COUNT).offset(intPageOffsetNum)
    getShortPosts(aryPosts)
    getRightColumnData
    slim :blog
  end
  get '/article/:name' do
    @aryArticle = Post.where(post_id: params[:name])
    @aryTags = Tag.joins(:taglinks).select(:tag_name, :post_id, :tag_id).where(taglinks: {post_id: params[:name]})
    getRightColumnData
    slim :article
  end
  get '/tag/:name' do
    intPageOffsetNum = getPageOffset(params[:page])

    aryPosts = Post.joins(:taglinks).where(taglinks: {tag_id: params[:name]}).order(post_id: 'desc').limit(POST_LIMIT_COUNT).offset(intPageOffsetNum)
    getPagerCount(aryPosts.count)
    getShortPosts(aryPosts)
    getRightColumnData
    slim :blog
  end
  get '/css/stylesheet.css' do
    sass :'css/stylesheet'
  end

  get '/js/javascript.js' do
    coffee :'js/javascript'
  end
  def getShortPosts(aryPosts)
    # 記事一覧表示用の投稿データを取得する.
    @intCount = aryPosts.count - 1
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
      @aryShortPost.push(strShortPost)
      @aryUpdateDate.push(post.updated_at)

      aryTags = Tag.joins(:taglinks).select(:tag_name, :tag_id).where(taglinks: {post_id: post.post_id})
      aryTagName = []
      aryTagUrl = []
      aryTags.each do |tag|
        aryTagName << tag.tag_name
        aryTagUrl << TAG_URL_DIR + tag.tag_id.to_s
      end
      @aryTagNames << aryTagName
      @aryTagUrls << aryTagUrl
    end
  end
  def getRightColumnData()
    # 右カラムのデータを取得する.
    # 追加済みのタグを取得する.
    @aryAllTags = Tag.all.order(tag_name: 'asc')
    # 最近の投稿から10件取得する.
    @aryCurrentPosts = Post.select(:post_id, :post_title).order(updated_at: 'desc').limit(10)
  end
  def getPagerCount(postCount)
    # ページャー数を取得する.
    @intPagerCount = (postCount.to_f / POST_LIMIT_COUNT.to_f).ceil

    if @intPagerCount <= 1
      @isPagerEnable = false
    else
      @isPagerEnable = true
    end
  end
  def getPageOffset(pageNum)
    # 遷移したページ数に合致した記事を表示するための、オフセット値を取得する.
    if (pageNum == nil)||(pageNum.to_i == 1)
      intPageOffsetNum = 0
    else
      intPageOffsetNum = (pageNum.to_i - 1) * POST_LIMIT_COUNT
    end
  end
end
