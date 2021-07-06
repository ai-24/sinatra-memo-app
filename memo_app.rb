require 'sinatra'
require 'sinatra/reloader'
require "json"
require 'securerandom'

def files
file_name = Dir.glob("*.json")
file_name.map do |f|
  File.open("#{f}",'r') do |file|
    JSON.load(file)
  end
end
end

get '/' do
  @tag = 'ホーム|メモアプリ'
  @files = files.sort { |a,b| b["time"] <=> a["time"] }
  @size = @files.size
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
  @file_name = SecureRandom.uuid
  File.open("#{@file_name}.json",'w') do |file|
    @time = File.ctime("#{@file_name}.json")
    hash = { id: @file_name, title: @title, content: @content, time: @time }
    JSON.dump(hash,file)
  end
  redirect to("/memos")
  erb :detail
end

get '/memos' do
  @tag = '保存しました|メモアプリ'
  erb :save
end

get '/memos/:id' do
  @tag = '詳細|メモアプリ'
  @id = params[:id]
  @file_detail = files.find { |x| x["id"].include?(@id)}
  erb :detail
end

get '/memos/:id/edit' do
  @tag = '編集|メモアプリ'
  @id = params[:id]
  @file_detail = files.find { |x| x["id"].include?(@id)}
  if @file_detail
    erb :edit_memo
  else
    redirect to('not_found')
  end
end

delete '/memos/:id' do
  @tag = '削除|メモアプリ'
  @id = params[:id]
  File.delete("#{@id}.json")
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
  File.open("#{@id}.json",'w') do |file|
    @time = File.ctime("#{@id}.json")
    hash = { id: @id, title: @title, content: @content, time: @time }
    JSON.dump(hash,file)
  end
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