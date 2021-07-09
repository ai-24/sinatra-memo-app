# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'securerandom'
require 'pg'

connect = PG.connect(dbname: 'memo_app')

get '/' do
  @tag = 'ホーム|メモアプリ'
  result = connect.exec('select id, title, time from memo')
  @array_memos = result.map do |memo|
    memo
  end
  @memos = @array_memos.sort { |a, b| b['time'] <=> a['time'] }
  @size = @memos.size
  erb :index
end

get '/memos/new' do
  @tag = '新規作成|メモアプリ'
  erb :new_memo
end

post '/memos' do
  @tag = '保存しました|メモアプリ'
  @title = params[:title]
  @content = params[:content]
  @id = SecureRandom.uuid
  @time = Time.now
  connect.exec_params('insert into memo(id, title, content, time) values ($1, $2, $3, $4)',
                      [@id, @title, @content, @time])
  redirect to('/memos')
  erb :detail
end

get '/memos' do
  @tag = '保存しました|メモアプリ'
  erb :save
end

get '/memos/:id' do
  @tag = '詳細|メモアプリ'
  @id = params[:id]
  @memo_detail = connect.exec('select id, title, content from memo where id = $1', [@id])
  erb :detail
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
  @tag = '削除|メモアプリ'
  @id = params[:id]
  connect.exec('delete from memo where id = $1', [@id])
  redirect to("/memos/#{@id}/delete")
  erb :delete
end

get '/memos/:id/delete' do
  @tag = '削除|メモアプリ'
  @id = params[:id]
  erb :delete
end

patch '/memos/:id' do
  @tag = '編集|メモアプリ'
  @id = params[:id]
  @title = params[:edit_title]
  @content = params[:edit_content]
  @time = Time.now
  connect.exec('update memo set title = $1, content = $2, time = $3 where id = $4', [@title, @content, @time, @id])
  redirect to("memos/#{@id}/save")
  erb :save
end

get '/memos/:id/save' do
  @tag = '編集|メモアプリ'
  @id = params[:id]
  erb :save
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
