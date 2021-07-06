require 'sinatra'
require 'sinatra/reloader'
require "json"
require 'securerandom'

get '/' do
  @title = 'ホーム|メモアプリ'
  file_name = Dir.glob("*.json")
  @file = file_name.map do |f|
    File.open("#{f}",'r') do |file|
      JSON.load(file)
    end
  end
  @files = @file.sort { |a,b| b["time"] <=> a["time"] }
  @numbers = @files.size
  erb :index
end

get '/memos/new' do
  @title = '新規作成|メモアプリ'
  erb :new_memo
end

post '/memos' do
  @title = '保存しました|メモアプリ'
  @name = params[:name]
  @contents = params[:contents]
  @file_name = SecureRandom.uuid
  File.open("#{@file_name}.json",'w') do |file|
    @time = File.ctime("#{@file_name}.json")
    hash = { id: @file_name, name: @name, contents: @contents, time: @time }
    JSON.dump(hash,file)
  end
  redirect to("/memos")
  erb :detail
end

get '/memos' do
  @title = '保存しました|メモアプリ'
  erb :save
end

get '/memos/:id' do
  @title = '詳細|メモアプリ'
  @id = params[:id]
  file_name = Dir.glob("*.json")
  @file = file_name.map do |f|
    File.open("#{f}",'r') do |file|
      JSON.load(file)
    end
  end
  @file_detail = @file.find { |x| x["id"].include?(@id)}
  erb :detail
end

get '/memos/:id/edit' do
  @title = '編集|メモアプリ'
  @id = params[:id]
  file_name = Dir.glob("*.json")
  @file = file_name.map do |f|
    File.open("#{f}",'r') do |file|
      JSON.load(file)
    end
  end
  @file_detail = @file.find { |x| x["id"].include?(@id)}
  erb :edit_memo
end

delete '/memos/:id' do
  @id = params[:id]
  File.delete("#{@id}.json")
  redirect to("/memos/#{@id}/delete")
  erb :delete
end

get '/memos/:id/delete' do
  @id = params[:id]
  erb :delete
end

patch '/memos/:id' do
  @title = '編集|メモアプリ'
  @id = params[:id]
  @name = params[:edit_name]
  @contents = params[:edit_contents]
  File.open("#{@id}.json",'w') do |file|
    @time = File.ctime("#{@id}.json")
    hash = { id: @id, name: @name, contents: @contents, time: @time }
    JSON.dump(hash,file)
  end
  redirect to("memos/#{@id}/save")
  erb :save
end

get '/memos/:id/save' do
  @id = params[:id]
  erb :save
end