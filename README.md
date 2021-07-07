#sinatra-memo-app
メモの作成、管理をローカル環境ですることのできるアプリのリポジトリです。

##Requirement 
Ruby 3.0.0<br>
sinatra 2.1.0<br>
sinatra-contrib 2.1.0<br>
webrick 1.7.0

##How to use
1.右上の`Fork`ボタンを押してください。

2.`#{自分のアカウント名}/sinatra-practice`が作成されます。

3.作業PCの任意のディレクトリにてgit cloneしてください。

4.上記に記載しているRequirementをGemfileを使ってインストールしてください。

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
```

##注意点
MACでのみ動作確認しています。