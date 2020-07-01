crumb :root do
  link "トップ", "/"
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

# item#show
crumb :item_show do |item|
  link item.title, item
  parent :items
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

# user#create
crumb :user_create do
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

# user#edit
crumb :edit_user do |user|
  link "Edit #{user.name}", edit_user_path(user)
  parent :show_user, user
end

# user#new
crumb :new_user do
  link "New User", new_user_path
  parent :users
end
