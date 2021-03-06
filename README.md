#sinatra-memo-app
メモの作成、管理をローカル環境ですることのできるアプリのリポジトリです。

##Requirement
Ruby 3.0.0<br>
sinatra 2.1.0<br>
sinatra-contrib 2.1.0<br>
webrick 1.7.0
pg 1.2.3

##How to use
1.右上の`Fork`ボタンを押してください。

2.`#{自分のアカウント名}/sinatra-practice`が作成されます。

3.作業PCの任意のディレクトリにてgit cloneしてください。

4.上記に記載しているRequirementがインストールされていなければ、インストールしてください。

5.`buncle exec ruby memo_app.rb`を実行してください。

6.ウェブブラウザで`localhost:4567`にアクセスするとホームページが表示されます。<br>
＊Chrome、Safari、Firefoxで動作確認済

##Installation
bundlerを使用していきます。
bundlerが作業PCにインストールされていなければ、`gem install bundler`でインストールしてください。

1.`git clone`したディレクトリ上で`bundle init`を実行してください。

2.作成されたGemfileに下記の内容をコピーして、`bundle install`してください。<br>
```
# frozen_string_literal: true

source "https://rubygems.org"

git_source(:github) {|repo_name| "https://github.com/#{repo_name}" }

gem "sinatra"
gem "sinatra-contrib"
gem 'webrick'
gem 'pg'
```

### 以降DBを使用するためのインストール・設定です。
Homebrewを使用していきます。
1. `$ brew install postgresql`コマンドでPostgreSQLをインストール
2. `$ brew services start postgresql`でPostgreSQLを自動起動するように設定します。
3. `$ psql -U${USER} postgres`でPostgreSQLにログインする
4. `postgres=# create user postgres with SUPERUSER;`で
操作用ユーザーPostgresを作成
   
5. `$ psql -Upostgres`でログインし直し`postgres=# create database memo_app owner=postgres;`でデータベースを作成
6. memo_appにログインした状態で`memo_app=#create table memo(id integer not null, title text, content text, time date, primary key(id));`でテーブルを作成。

##注意点
MACでのみ動作確認しています。
