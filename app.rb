require 'coffee-script'
require 'sass'
require 'sinatra'
require 'sinatra/base'
require 'sinatra/reloader'
require 'slim'

require './models/dbAccessers'

# TODO:テスト用に5件1ページで表示中。分量的にはこのままでもいいかも？
POST_LIMIT_COUNT = 5

class MainApp < Sinatra::Base

  intPageOffsetNum = 0
  intPostCount = 0

  get '/' do
    intPageOffsetNum = getPageOffset(params[:page])

    getPagerCount
    @aryPosts = Post.all.order(post_id: 'desc').limit(POST_LIMIT_COUNT).offset(intPageOffsetNum)
    getLinkedTags
    slim :blog
  end
  get '/tag/:name' do
    intPageOffsetNum = getPageOffset(params[:page])

    getPagerCount
    @aryPosts = Post.joins(:taglinks).where(taglinks: {tag_id: params[:name]}).order(post_id: 'desc').limit(POST_LIMIT_COUNT).offset(intPageOffsetNum)
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
    # 右カラム、各記事に設定されたタグのデータを取得する.

    # TODO: Taglinkは、現在表示している記事のみのタグを表示したい。
    @aryTags = Tag.joins(:taglinks).select(:tag_name, :post_id, :tag_id)
    @aryAllTags = Tag.all.order(tag_name: 'asc')
    # 最近の投稿から10件取得する.
    @aryCurrentPosts = Post.select(:post_id, :post_title).order(updated_at: 'desc').limit(10)
  end
  def getPagerCount()
    # ページャー数を取得する.
    @intPagerCount = (Post.count.to_f / POST_LIMIT_COUNT.to_f).ceil
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
