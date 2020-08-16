# Chill℃

「おいしい冷凍食品の発見」をコンセプトにしたレビューサイトです。「レビューの閲覧・投稿」、「検索機能」、「食べた・食べたい商品のメモ」、「興味のあるユーザへのダイレクトメッセージ」を通じて、「感想や情報をシェアして楽しむツール」としてご利用いただけます。

URL: https://chilled.site

## 構成

* インフラ
  * AWS（ EC2 / ALB / Route53 / ACM / RDS / VPC )

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
  
* CI / CD
  * CircleCI / Rubocop / Rspec / Capistrano 
