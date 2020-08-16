# Chill℃

「おいしい冷凍食品の発見」をコンセプトにしたレビューサイトです。「レビューの閲覧・投稿」、「検索機能」、「食べた・食べたい商品のメモ」、「興味のあるユーザへのダイレクトメッセージ」を通じて、「感想や情報をシェアして楽しむツール」としてご利用いただけます。

URL: https://chilled.site

## 構成

* インフラ
  * AWS（ EC2 / ALB / Route53 / ACM / RDS / VPC )
  * Gmail (メール送信)

* フロントエンド
  * jQuery / HTML / CSS
  
* バックエンド
  * Ruby 2.6.6
  * Rails 5.2.4
  
* Webサーバ
  * Nginx

* APサーバ
  * Puma
 
* データベース
  * RDS for MySQL 5.7.28
  * Redis (リアルタイムチャット機能、ログインユーザのアクティブ判定でWebsocketのアダプターとして使用)
  
* CI / CD
  * CircleCI / Rubocop / Rspec / Capistrano 
  
## クラウドアーキテクチャ

## 特に見ていただきたい点

## 機能一覧
* 全ユーザが利用可能
  * かんたんログイン 
  * 検索機能
  * ユーザ登録機能
  * セッション維持機能(次回からログインを省略：セッションIDをcookieに20年保存)
  * パスワード再設定機能
  * チャット機能 / リアルタイム既読判定
  * ログイン中アクティブユーザの緑アイコン表示
  * ぱんくずリスト
 
* 管理者ユーザのみ利用可能
  * 商品投稿 (管理者のみ)
 
* 一般ユーザのみ利用可能
  * 商品レビュー投稿 (一般ユーザのみ)
  * 迷惑ユーザブロック機能 (一般ユーザのみ)
  * コメント (一般ユーザのみ)
  * 食べた！ / 食べたい！の商品メモ機能 (一般ユーザのみ)
  * 通知機能 (一般ユーザのみ)
  * フォロー機能 (一般ユーザのみ)
  * 商品レビュー時のタグ付け機能 (一般ユーザのみ)
  * ランキング表示機能 (全ユーザ)



