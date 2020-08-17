# Chill℃

「おいしい冷凍食品の発見」をコンセプトにしたレビューサイトです。

「レビューの閲覧や投稿」、「検索機能」、「食べた・食べたい商品のメモ」、「興味のあるユーザへのメッセージ」を通じて、「感想や情報をシェアして楽しむツール」としてご利用いただけます。

URL: https://chilled.site

![top](https://user-images.githubusercontent.com/63604398/90354588-b7ab8e80-e084-11ea-82ed-f53e6e0b606f.png)

## 構成

* インフラ
  * AWS（ EC2 / ALB / Route53 / ACM / RDS / VPC )
  * Gmail (メール送信)

* フロントエンド
  * JavaScript / jQuery / HTML / CSS
  
* バックエンド
  * Ruby 2.6.6
  * Rails 5.2.4
  
* Webサーバ
  * Nginx

* APサーバ
  * Puma
 
* データベース
  * RDS for MySQL 5.7.28
  * Redis (リアルタイムチャット機能、ログインユーザのアクティブ判定でAction CableのPub/Subキューとして使用)
  
* CI / CD
  * CircleCI / Rubocop / Rspec / Capistrano 
  
## クラウドアーキテクチャ
![test (6)](https://user-images.githubusercontent.com/63604398/90353369-f93a3a80-e080-11ea-8f25-fa5e72ea69e0.png)


## 特に見ていただきたい点
* レビューサービス × 好きなユーザへのダイレクトメッセージ機能
  * レビューサービスの多くでは、誰がレビューを書いたかはわかるものの、ユーザとの交流方法は、レビューへのいいねやコメントに限られます。
  
    当サイトでは、気に入ったユーザに直接メッセージを送る機能を搭載しており、より深いコミュニケーションを行うことが可能になっています。不快・迷惑なユーザについては、ブロック機能を搭載することで相手のレビューやコメントを非表示にし、メッセージも送ることができないようにしました。

* 商品ページ、レビュー、コメントの全てを1つのページで表示
  * 参考にした漫画や映画のレビューサイトでは、マンガや映画の紹介ページと個々のレビューページが独立したURLになっているものがあり、レビューを見るときに元のページを離れてしまうため、情報が分散してしまっているように思われました。
  
    レビューの1件1件はそれほど多くの情報量ではないため、あえて別のページを用意する必要もないと考え、全てを単一のページに表示する仕様にしました。Topページに紹介されている人気のレビューをクリックすると、そのレビューを最上位に表示するようにしています。

* テストケースの数
  * 2020年8月17日現在、単体テストの数は237、統合テストも含めた総テスト数は293となっています。
  
    開発当初はテストをほとんど書いておらず、ブラウザでの目視検査を通り抜けていたものの、Rspecを通すことで初めて発見されたバグも複数経験しました。そのため、「テストをしっかり書いた上で、安心して機能追加やリファクタリングを行う」という作法を身をもってよく理解しています。


## 機能一覧
* 全ユーザが利用可能
  * かんたんログイン
  * 検索機能
  * ユーザ登録機能
  * ブラウザを閉じてもセッション維持 (次回からログインを省略：セッション情報を署名付きcookieに20年保存)
  * パスワード再設定機能
  * チャット機能 / リアルタイム既読判定
  * ログイン中アクティブユーザの緑アイコン表示
  * ぱんくずリスト
 
* 管理者ユーザのみ利用可能
  * 商品投稿 
 
* 一般ユーザのみ利用可能
  * 商品レビュー投稿 
  * 迷惑ユーザブロック機能 
  * コメント機能
  * 食べた！ / 食べたい！の商品メモ機能 
  * 通知機能 
  * フォロー機能 
  * 商品レビュー時のタグ付け機能
  * ランキング表示機能 



