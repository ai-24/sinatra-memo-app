# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'
require 'securerandom'

def files
  file_name = Dir.glob('*.json')
  file_name.map do |f|
    File.open(f, 'r') do |file|
      JSON.parse(file.read)
    end
  end
end

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
  file_name = SecureRandom.uuid
  time = Time.now
  File.open("#{file_name}.json", 'w') do |file|
    hash = { id: file_name, title: title, content: content, time: time }
    JSON.dump(hash, file)
  end
  redirect to('/memos?complete=1')
end

get '/memos' do
  @tag = 'ホーム|メモアプリ'
  @files = files.sort_by { |f| [f['time']] }.reverse
  @size = @files.size
  erb :index
end

get '/memos/:id' do
  @tag = '詳細|メモアプリ'
  @id = params[:id]
  @file_detail = files.find { |x| x['id'] == @id }
  if @file_detail
    erb :detail
  else
    redirect to('not_found')
  end
end

get '/memos/:id/edit' do
  @tag = '編集|メモアプリ'
  @id = params[:id]
  @file_detail = files.find { |x| x['id'].include?(@id) }
  if @file_detail
    erb :edit_memo
  else
    redirect to('not_found')
  end
end

delete '/memos/:id' do
  id = params[:id]
  File.delete("#{id}.json")
  redirect to('/memos?delete=1')
end

patch '/memos/:id' do
  id = params[:id]
  title = params[:edit_title]
  content = params[:edit_content]
  File.open("#{id}.json", 'w') do |file|
    time = Time.now
    hash = { id: id, title: title, content: content, time: time }
    JSON.dump(hash, file)
  end
  redirect to('memos?save=1')
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
