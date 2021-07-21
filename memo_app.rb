# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'securerandom'
require 'pg'

connect = PG.connect(dbname: 'memo_app')

get '/' do
  redirect to('/memos')
end

get '/memos/new' do
  @tag = '新規作成|メモアプリ'
  erb :new_memo
end

post '/memos' do
  title = params[:title]
  content = params[:content]
  id = SecureRandom.uuid
  time = Time.now
  connect.exec_params('insert into memo(id, title, content, time) values ($1, $2, $3, $4)',
                      [id, title, content, time])
  redirect to('/memos?complete=1')
end

get '/memos' do
  @tag = 'ホーム|メモアプリ'
  result = connect.exec('select id, title, time from memo')
  array_memos = result.map { |memo| memo }
  @memos = array_memos.sort_by { |a| a['time'] }.reverse
  @size = @memos.size
  erb :index
end

get '/memos/:id' do
  @tag = '詳細|メモアプリ'
  @id = params[:id]
  @memo_detail = connect.exec('select id, title, content from memo where id = $1', [@id])
  if @memo_detail
    erb :detail
  else
    redirect to('not_found')
  end
end

get '/memos/:id/edit' do
  @tag = '編集|メモアプリ'
  @id = params[:id]
  @memo_detail = connect.exec('select title, content from memo where id = $1', [@id])
  if @memo_detail
    erb :edit_memo
  else
    redirect to('not_found')
  end
end

delete '/memos/:id' do
  id = params[:id]
  connect.exec('delete from memo where id = $1', [id])
  redirect to('/memos?delete=1')
end

patch '/memos/:id' do
  id = params[:id]
  title = params[:edit_title]
  content = params[:edit_content]
  time = Time.now
  connect.exec('update memo set title = $1, content = $2, time = $3 where id = $4', [title, content, time, id])
  redirect to('memos?edit=1')
end

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end

  def hattr(text)
    Rack::Utils.escape_path(text)
  end
end

not_found do
  @tag = '404 ページが存在しません'
  '404 ページが存在しません'
end
