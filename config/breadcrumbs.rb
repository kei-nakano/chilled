crumb :root do
  link "トップ", "/"
end

# reviews
crumb :reviews do
  link "レビュー一覧", "/search?type=review"
  parent :search
end

# review#edit
crumb :review_edit do |item|
  link "レビュー編集", "#"
  parent :item_show, item
end

# review#new
crumb :review_new do |item|
  link "レビュー投稿", "#"
  parent :item_show, item
end

# manufacturers
crumb :manufacturers do
  link "メーカー一覧", "/search?type=manufacturer"
  parent :search
end

# manufacturer#show
crumb :manufacturer_show do |manufacturer|
  link manufacturer.name, "/manufacturers/#{manufacturer.id}/edit"
  parent :manufacturers
end

# manufacturer#edit
crumb :manufacturer_edit do |manufacturer|
  link "メーカー編集", "#"
  parent :manufacturer_show, manufacturer
end

# categories
crumb :categories do
  link "カテゴリ一覧", "/search?type=category"
  parent :search
end

# category#show
crumb :category_show do |category|
  link category.name, "/categories/#{category.id}/edit"
  parent :categories
end

# category#edit
crumb :category_edit do |category|
  link "カテゴリ編集", "#"
  parent :category_show, category
end

# session
crumb :session do
  link "ログイン", "/login"
  parent :root
end

# password_forget
crumb :password_forget do
  link "パスワードがわからない場合", "/password_resets/new"
  parent :session
end

# password_reset
crumb :password_reset do
  link "パスワード再設定", "#"
  parent :password_forget
end

# notice
crumb :notice do
  link "通知", "/notices"
  parent :root
end

# no_notice
crumb :no_notice do
  link "現在通知はありません", "#"
  parent :notice
end

# search
crumb :search do
  link "検索", "/search"
  parent :root
end

# search#show
crumb :search_show do |keyword|
  link "「#{keyword}」の検索結果", "/search"
  parent :search
end

# items
crumb :items do
  link "商品一覧", "/search?type=item"
  parent :search
end

# item#edit
crumb :item_edit do |item|
  link "商品編集", "#"
  parent :item_show, item
end

# item#show
crumb :item_show do |item|
  link item.title, item
  parent :items
end

# item#new
crumb :item_new do
  link "商品投稿", "#"
  parent :root
end

# users
crumb :users do
  link "ユーザー一覧", "/search?type=user"
  parent :search
end

# user#show
crumb :user_show do |user|
  link user.name, user
  parent :users
end

# user#edit
crumb :user_edit do |user|
  link "アカウント編集", "#"
  parent :user_show, user
end

# user#new
crumb :user_new do
  link "新規登録", "#"
  parent :root
end

# room#index
crumb :room_index do |user|
  link "メッセージ", "/rooms"
  parent :user_show, user
end

# room#show
crumb :room_show do |current_user, other|
  link other.name, "#"
  parent :room_index, current_user
end
